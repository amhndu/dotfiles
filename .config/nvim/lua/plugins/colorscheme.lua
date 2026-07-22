return {
  {
    'nyoom-engineering/oxocarbon.nvim',
    priority = 1000,
  },
  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    config = true,
    opts = {
      contrast = 'hard',
    },
  },
  { 'Mofiqul/dracula.nvim' },
  {
    'rebelot/kanagawa.nvim',
    pin = true,
    priority = 1000,
  },
  {
    'catppuccin/nvim',
    pin = true,
    name = 'catppuccin',
    priority = 1000,
  },
  {
    'f-person/auto-dark-mode.nvim',
    pin = true,
    opts = {
      set_dark_mode = function()
        vim.api.nvim_set_option_value('background', 'dark', {})
        vim.cmd.colorscheme 'oxocarbon'
        vim.cmd.hi 'Comment gui=none'
      end,
      set_light_mode = function()
        vim.api.nvim_set_option_value('background', 'light', {})
        vim.cmd.colorscheme 'oxocarbon'
        vim.cmd.hi 'Comment gui=none'
      end,
    },
  },
}
