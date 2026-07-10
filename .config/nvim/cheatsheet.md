Some common keybinds / commands:

# Movement
src: lua/config/movements.lua

<c-hjkl>    |   Move across windows
H           |   Move half screen up and center cursor
L           |   Move half screen down and center cursor
<leader>v   |   New vsplit
<leader>o   |   Only current split
gv          |   Go to symbol defintion in vsplit (ensures only two vsplits)
<action>vb  |   Back but include current character sdfdf

TODO: hydra and modal movement for window/etc

# Text Objects
{op}i{obj}  | {op}erator (e.g. c, d) inner {obj}ect (e.g. ", ', w, p, s, [, {)
{op}a{obj}  | {op}erator (e.g. c, d) around {obj}ect (e.g. ", ', w, p, s, [, {)
TODO: tree-sitter text objs

# Jump
src: lua/plugins/languages.lua

gd          |   Go to symbol definition
gr          |   Search references to symbol
<leader>D   |   Go to symbol's TYPE definition
gx          |   Open URI under cursor
<c-]>       |   Open tag under cursor (useful in help)

# Macro
q{register}     |   Start recording macro to {register} (in a-z)
@{register}     |   Apply macro from {register}



# Search
src: lua/plugins/telescope.lua, lua/plugins/languages.lua
<leader>f   |   Find Files
<leader>sg  |   Grep Files
<leader>ws  |   Search symbols across files
<leader>ds  |   Search symbols across in current file
<leader> leader> | Find open buffers

# LSP
src: lua/plugins/languages.lua

K           |   Display doc for symbol
<c-n> / Tab |   next suggestion in completion
<c-p>       |   prev suggestion in completion
<leader>rn  |   Rename symbol

# Diagnostics
src: lua/config/diagnostics.lua

<leader>e   |   Show diagnostic
<leader>ca  |   Open Code Actions
<leader>q   |   Show all diagnostic in quickfix list
]d / [d     |   Jump to next / prev diagnostic

# Format
src: lua/plugins/editing.lua

<leader>bf  |   Buffer auto-format

# NeoTree
src: lua/plugins/panels.lua

\           | Toggle
s           | open in new vsplit


# Git
src: lua/plugins/git.lua

TODO

# C/C++/Rust
src: lua/plugins/languages.lua

<leader>ch  |   Switch header/source (C/C++)
<leader>gI  |   Jump to impl/trait
<leader>gD  |   Jump to decl


# Scheme/Lisp
src: lua/plugins/languages.lua

TODO


# Movement diagram

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

