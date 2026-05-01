return {
  -- copilot / LLM extensions
  {
    'github/copilot.vim',
    config = function()
      -- disable by default
      vim.g.copilot_enabled = false
      vim.keymap.set('i', '<C-p>', '<Plug>(copilot-accept-word)', { desc = 'Invoke Copilot' })
    end,
  },
}
