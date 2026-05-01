-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Rebind <C-d> / <C-u> so cursor is always centered after movign
vim.keymap.set('n', 'H', '<C-u>zz', { desc = 'Center cursor after moving up half-page' })
vim.keymap.set('n', 'L', '<C-d>zz', { desc = 'Center cursor after moving down half-page' })


