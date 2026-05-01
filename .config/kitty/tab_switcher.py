# Kitty tab switcher kitten — fuzzy-searchable tab picker using kitty's TUI API.
#
# Architecture:
#   main()          — runs in an overlay window (has a tty), fetches tab data
#                     via remote control, displays the TUI, returns selected tab ID.
#   handle_result() — runs in the kitty process after main() exits, receives the
#                     tab ID string and calls boss.set_active_tab() to switch.
#
# This split is required because:
#   - main() has a tty (needed for Loop/Handler TUI) but no access to boss
#   - handle_result() has boss but no tty (no_ui=True hangs; Loop needs /dev/tty)
#
# Tab data comes from `kitty @ ls` JSON via main.remote_control(). The remote
# control API doesn't expose tab activation history, so we can't sort by recency.
# Tabs are sorted focused-first, then alphabetically by program and title.
#
# CWD is taken from the foreground process (foreground_processes[0].cwd), falling
# back to the window's cwd. This shows where the running command actually is,
# not the shell's startup directory.
#
# Search uses Levenshtein distance: each tab is scored against the query, and
# tabs with score <= query length are shown, sorted by best match. Exact
# substring matches score 0. Words are compared prefix-truncated to query
# length to handle partial typing.
#
# Escape always quits immediately (even during search) — single keypress exit.
# Search is active by default on launch so you can start typing immediately.
#
# The "kitty" program is filtered out — that's the switcher's own overlay window.
#
# Pyright errors on kitty/kittens imports are expected — those modules only
# exist inside kitty's embedded Python runtime, not on the system PATH.

import json
import os
from typing import List, Optional, Tuple

from kitty.typing import KeyEventType
from kitty.utils import ScreenSize

from kittens.tui.handler import Handler, kitten_ui, result_handler
from kittens.tui.line_edit import LineEdit
from kittens.tui.loop import Loop
from kittens.tui.operations import styled


class TabInfo:
    def __init__(self, tab_id: int, is_focused: bool, program: str,
                 tab_title: str, cmdline: str, cwd: str):
        self.tab_id = tab_id
        self.is_focused = is_focused
        self.program = program
        self.tab_title = tab_title
        self.cmdline = cmdline
        self.cwd = cwd


class TabSwitcherHandler(Handler):
    """TUI handler following kitty's Handler pattern (see kittens/themes/main.py).

    Layout: header row (dimmed), scrollable tab list, bottom bar with search
    prompt or status. Scrolling keeps the cursor visible with a sliding window.
    """

    def __init__(self, tabs: List[TabInfo]):
        self.all_tabs = tabs
        self.filtered_tabs = list(tabs)
        self.header, self.all_lines = format_tabs(tabs)
        self.filtered_lines = list(self.all_lines)
        self.current_idx = 0
        # Search active by default so user can type immediately
        self.searching = True
        self.line_edit = LineEdit()
        self.result: Optional[int] = None

    def initialize(self) -> None:
        self.cmd.set_cursor_visible(False)
        self.cmd.set_line_wrapping(False)
        self.cmd.set_window_title('Switch tab')
        self.draw_screen()

    def finalize(self) -> None:
        self.cmd.set_cursor_visible(True)

    @Handler.atomic_update
    def draw_screen(self) -> None:
        self.cmd.clear_screen()

        if self.header:
            self.cmd.styled('  ' + self.header, dim=True)
            self.print()

        if not self.filtered_tabs:
            self.print(styled(' No matching tabs ', fg='red'))
            self.draw_bottom_bar()
            return

        # -2: one row for header, one for bottom bar
        num_rows = self.screen_size.rows - 2
        before_num = min(self.current_idx, num_rows - 1)
        start = self.current_idx - before_num

        for i in range(start, min(start + num_rows, len(self.filtered_lines))):
            is_current = i == self.current_idx
            prefix = '>' if is_current else ' '
            self.cmd.styled(prefix + ' ', fg='green')
            self.cmd.styled(self.filtered_lines[i], bold=is_current, fg='green' if is_current else None)
            self.print()

        self.draw_bottom_bar()

    def draw_bottom_bar(self) -> None:
        self.cmd.set_cursor_position(0, self.screen_size.rows)
        self.cmd.clear_to_eol()
        if self.searching:
            self.cmd.set_cursor_visible(True)
            self.line_edit.write(self.write, prompt='> ')
        else:
            self.cmd.set_cursor_visible(False)
            count = f' {len(self.filtered_tabs)}/{len(self.all_tabs)} '
            self.cmd.styled(count, reverse=True)
            self.cmd.styled(' /', reverse=True, italic=True)
            self.cmd.styled(' search ', reverse=True)

    def apply_filter(self) -> None:
        query = self.line_edit.current_input.lower()
        if not query:
            self.filtered_tabs = list(self.all_tabs)
            self.filtered_lines = list(self.all_lines)
        else:
            # Score every tab and keep only close matches, sorted best-first
            scored = []
            for tab, line in zip(self.all_tabs, self.all_lines):
                words = [tab.program, tab.tab_title, tab.cmdline, tab.cwd]
                score = best_word_distance(query, words)
                # Threshold: allow up to as many edits as characters in query
                if score <= len(query):
                    scored.append((score, tab, line))
            scored.sort(key=lambda x: x[0])
            self.filtered_tabs = [s[1] for s in scored]
            self.filtered_lines = [s[2] for s in scored]
        self.current_idx = min(self.current_idx, max(0, len(self.filtered_tabs) - 1))

    def move(self, delta: int) -> None:
        if not self.filtered_tabs:
            return
        self.current_idx = (self.current_idx + delta) % len(self.filtered_tabs)
        self.draw_screen()

    def on_key_event(self, key_event: KeyEventType, in_bracketed_paste: bool = False) -> None:
        if self.searching:
            self.on_searching_key_event(key_event, in_bracketed_paste)
        else:
            self.on_browsing_key_event(key_event, in_bracketed_paste)

    def on_browsing_key_event(self, key_event: KeyEventType, in_bracketed_paste: bool = False) -> None:
        if key_event.matches('esc') or key_event.matches_text('q'):
            self.quit_loop(1)
            return
        if key_event.matches_text('j') or key_event.matches('down'):
            return self.move(1)
        if key_event.matches_text('k') or key_event.matches('up'):
            return self.move(-1)
        if key_event.matches('page_down'):
            return self.move(self.screen_size.rows - 2)
        if key_event.matches('page_up'):
            return self.move(-(self.screen_size.rows - 2))
        if key_event.matches('/'):
            self.searching = True
            self.line_edit.clear()
            self.draw_screen()
            return
        if key_event.matches('enter'):
            if self.filtered_tabs:
                self.result = self.filtered_tabs[self.current_idx].tab_id
                self.quit_loop(0)
            return

    def on_searching_key_event(self, key_event: KeyEventType, in_bracketed_paste: bool = False) -> None:
        # Single escape always quits — no two-step exit
        if key_event.matches('esc'):
            self.quit_loop(1)
            return
        # Enter confirms search and switches to browse mode
        if key_event.matches('enter'):
            self.searching = False
            self.draw_screen()
            return
        if key_event.matches('down'):
            return self.move(1)
        if key_event.matches('up'):
            return self.move(-1)
        if key_event.text:
            self.line_edit.on_text(key_event.text, in_bracketed_paste)
        elif not self.line_edit.on_key(key_event):
            return
        self.apply_filter()
        self.draw_screen()

    def on_resize(self, screen_size: ScreenSize) -> None:
        self.screen_size = screen_size
        self.draw_screen()

    def on_interrupt(self) -> None:
        self.quit_loop(1)

    def on_eot(self) -> None:
        self.quit_loop(1)


def collect_tabs(remote_control) -> List[TabInfo]:
    """Fetch tabs via kitty remote control and return sorted TabInfo list.

    Uses foreground_processes[0].cwd for the working directory (the actual cwd
    of the running command), falling back to the window cwd if unavailable.
    """
    cp = remote_control(["ls"], capture_output=True)
    os_windows = json.loads(cp.stdout.decode())

    tabs = []
    for os_window in os_windows:
        for tab in os_window["tabs"]:
            window = tab["windows"][0]
            procs = window.get("foreground_processes", [{}])
            cmdline = procs[0].get("cmdline", [""]) if procs else [""]
            program = os.path.basename(cmdline[0]) if cmdline[0] else ""
            # Filter out the switcher's own overlay window
            if tab["title"] == "kitty":
                continue
            tabs.append(TabInfo(
                tab_id=tab["id"],
                is_focused=tab["is_focused"],
                program=program.replace("\n", " "),
                tab_title=tab["title"].replace("\n", " "),
                cmdline=window.get("last_reported_cmdline", "").replace("\n", " "),
                cwd=procs[0].get("cwd", window.get("cwd", "")).replace("\n", " ") if procs else window.get("cwd", "").replace("\n", " "),
            ))

    tabs.sort(key=lambda t: (t.is_focused, t.program, t.tab_title), reverse=True)
    return tabs


def levenshtein(a: str, b: str) -> int:
    """Standard Levenshtein edit distance, iterative DP."""
    if len(a) < len(b):
        return levenshtein(b, a)
    if not b:
        return len(a)
    prev = list(range(len(b) + 1))
    for i, ca in enumerate(a):
        curr = [i + 1]
        for j, cb in enumerate(b):
            curr.append(min(
                prev[j + 1] + 1,
                curr[j] + 1,
                prev[j] + (0 if ca == cb else 1),
            ))
        prev = curr
    return prev[-1]


def best_word_distance(query: str, words: List[str]) -> int:
    """Minimum Levenshtein distance between query and any word/substring in fields.

    Each word is prefix-truncated to query length before comparing, so partial
    typing of a long word scores well. Exact substring match always returns 0.
    """
    query = query.lower()
    best = len(query) + 1
    for field in words:
        field = field.lower()
        if query in field:
            return 0
        for word in field.split():
            best = min(best, levenshtein(query, word[:len(query)]))
            if best == 0:
                return 0
    return best


def format_tabs(tabs: List[TabInfo]) -> Tuple[str, List[str]]:
    """Format tabs as aligned columns. Returns (header, lines).

    Columns: ID, CMD, CWD, TITLE — padded to the widest value in each column.
    """
    if not tabs:
        return "", []

    id_w = max(len("ID"), max(len(str(t.tab_id)) for t in tabs))
    cmd_w = max(len("CMD"), max(len(t.cmdline) for t in tabs))
    cwd_w = max(len("CWD"), max(len(t.cwd) for t in tabs))

    header = (
        f'{"ID":<{id_w}}  '
        f'{"CMD":<{cmd_w}}  '
        f'{"CWD":<{cwd_w}}  '
        f'{"TITLE"}'
    )

    lines = []
    for t in tabs:
        lines.append(
            f'{str(t.tab_id):<{id_w}}  '
            f'{t.cmdline:<{cmd_w}}  '
            f'{t.cwd:<{cwd_w}}  '
            f'{t.tab_title}'
        )
    return header, lines


# main() runs in an overlay window with a tty — required for Loop/Handler TUI.
# @kitten_ui(allow_remote_control=True) injects main.remote_control for kitty @ commands.
@kitten_ui(allow_remote_control=True)
def main(args: list[str]) -> str:
    tabs = collect_tabs(main.remote_control)
    if not tabs:
        return ""

    loop = Loop()
    handler = TabSwitcherHandler(tabs)
    loop.loop(handler)

    if handler.result is not None:
        return str(handler.result)
    return ""


# handle_result() runs inside the kitty process — has access to boss for tab switching
# but no tty. Receives the tab ID string returned by main().
@result_handler()
def handle_result(args: list[str], answer: str, target_window_id: int, boss) -> None:
    if not answer:
        return
    tab_id = int(answer)
    for os_window in boss.os_window_map.values():
        for tab in os_window.tabs:
            if tab.id == tab_id:
                boss.set_active_tab(tab)
                return
