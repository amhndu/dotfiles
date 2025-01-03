return {
  -- fs tree side panel
  {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
    },
    cmd = 'Neotree',
    keys = {
      { '\\', ':Neotree reveal<CR>', { desc = 'NeoTree reveal' } },
    },
    opts = {
      filesystem = {
        window = {
          mappings = {
            ['\\'] = 'close_window',
            ['l'] = 'open',
            ['h'] = 'close_node',
          },
        },
        follow_current_file = {
          enabled = false,
          leave_dirs_open = false,
        },
        filtered_items = {
          hide_gitignored = false,
          never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
            '.DS_Store',
            'thumbs.db',
          },
          always_show = { -- remains visible even if other settings would normally hide it
            '.gitignore',
            '.vscode',
            '.github',
          },
        },
        default_component_configs = {
          indent = {
            with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
            expander_collapsed = '',
            expander_expanded = '',
            expander_highlight = 'NeoTreeExpander',
          },
          git_status = {
            symbols = {
              unstaged = '󰄱',
              staged = '󰱒',
            },
          },
        },
      },
    },
    init = function()
      vim.fn.sign_define('DiagnosticSignError', { text = ' ', texthl = 'DiagnosticSignError' })
      vim.fn.sign_define('DiagnosticSignWarn', { text = ' ', texthl = 'DiagnosticSignWarn' })
      vim.fn.sign_define('DiagnosticSignInfo', { text = ' ', texthl = 'DiagnosticSignInfo' })
      vim.fn.sign_define('DiagnosticSignHint', { text = '󰌵', texthl = 'DiagnosticSignHint' })
    end,
  },
}
