return {
  'NMAC427/guess-indent.nvim',

  {
    'shaunsingh/nord.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'nord'
    end,
  },

  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup {
        view = { width = 35 },
        update_focused_file = { enable = true, update_root = true },
        filesystem_watchers = { enable = true },
        git = {
          enable = true,
          ignore = false,
        },
        renderer = {
          icons = {
            show = {
              git = true,
            },
          },
        },
      }

      vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeFindFileToggle<CR><cmd>NvimTreeFocus<CR>', {
        desc = 'Focus file tree on current file',
      })
      vim.keymap.set('n', '<leader>r', '<cmd>NvimTreeRefresh<CR>', {
        desc = 'Refresh file tree',
      })
    end,
  },

  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require 'telescope.builtin'

      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
    end,
  },

  { 'lewis6991/gitsigns.nvim', opts = {} },
}
