local parsers = {
  'bash',
  'json',
  'lua',
  'markdown',
  'markdown_inline',
  'python',
  'query',
  'toml',
  'vim',
  'vimdoc',
  'yaml',
}

return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = function()
      require('nvim-treesitter').install(parsers):wait(300000)
      require('nvim-treesitter').update(parsers):wait(300000)
    end,
    config = function()
      require('nvim-treesitter').setup()

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('treesitter', { clear = true }),
        callback = function()
          if pcall(vim.treesitter.start) then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
