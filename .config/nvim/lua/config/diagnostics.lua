-- Diagnostic sign glyphs. The diagnostic framework owns sign text since Neovim
-- 0.10, so configure it here via vim.diagnostic.config rather than sign_define.
vim.diagnostic.config {
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN] = ' ',
      [vim.diagnostic.severity.INFO] = ' ',
      [vim.diagnostic.severity.HINT] = '󰌵',
    },
  },
}

-- Diagnostic keymaps
--
-- vim.diagnostic.config {
--   jump = {
--     -- Show a floating diagnostic window
--     float = true,
--     -- only jump to errors
--     severity = { min = vim.diagnostic.severity.WARN },
--   },
-- }

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
