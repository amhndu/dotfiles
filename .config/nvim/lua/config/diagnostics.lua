-- Diagnostic sign glyphs. Since Neovim 0.10 the diagnostic framework owns sign
-- text; the pre-0.10 `sign_define('DiagnosticSign*')` approach no longer feeds
-- these on 0.11+. Configured once here (was previously also duplicated, with
-- conflicting icons, in neo-tree's init).
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
