Some common keybinds / commands:

# Movement
src: lua/config/movements.lua

<c-hjkl>    |   Move across windows
H           |   Move half screen up and center cursor
L           |   Move half screen down and center cursor

(defaults: H/L are remapped)
+-------------------------------+
^                               |
|c-y (keep cursor)              |
|c-u (move both)
|H(igh)             zt (top)    |
|                   ^           |
|           ze      |      zs   |
|M(iddle)  zh/zH <--zz--> zl/zL |   (*1)
|                   |           |
|                   v           |
|L(ow)              zb (bottom) |
|c-d (move both)
|c-e (keep cursor)              |
v                               |
+-------------------------------+

# NeoTree
src: lua/plugins/panels.lua

\           | Toggle
s           | open in new vsplit


# Search
src: lua/plugins/telescope.lua, lua/plugins/languages.lua
<leader>f   |   Find Files
<leader>sg  |   Grep Files
<leader>ws  |   Search symbols across files
<leader>ds  |   Search symbols across in current file

# Diagnostics
src: lua/config/diagnostics.lua

]d / [d     |   Jump to next / prev diagnostic
<leader>e   |   Show diagnostic
<leader>ca  |   Open Code Actions
<leader>q   |   Show all diagnostic in quickfix list

# LSP
src: lua/plugins/languages.lua

K           |   Display doc for symbol
<c-n> / Tab |   next suggestion in completion
<c-p>       |   prev suggestion in completion
<leader>rn  |   Rename symbol

# Jump
src: lua/plugins/languages.lua

gd          |   Go to symbol definition
gv          |   Go to symbol defintion in vsplit (ensures only two vsplits)
gr          |   Search references to symbol
<leader>D   |   Go to symbol's TYPE definition
gx          |   Open URI under cursor

# Format
src: lua/plugins/editing.lua

<leader>bf  |   Buffer auto-format

# Git
src: lua/plugins/git.lua

TODO

# C/C++
src: lua/plugins/languages.lua

<leader>ch  |   Switch header/source
<leader>gI  |   Jump to impl
<leader>gD  |   Jump to decl


# Scheme/Lisp
src: lua/plugins/languages.lua

TODO
