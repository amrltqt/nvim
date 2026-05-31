local servers = { 'pyright', 'ruff', 'lua_ls' }

local function executable(path)
  return path and path ~= '' and vim.fn.executable(path) == 1
end

local function first_executable(names)
  for _, name in ipairs(names) do
    local path = vim.fn.exepath(name)
    if executable(path) then
      return path
    end
  end
end

local function project_file(root_dir, filename)
  return vim.fs.joinpath(root_dir or vim.fn.getcwd(), filename)
end

local function get_python_path(root_dir)
  root_dir = root_dir or vim.fn.getcwd()

  for _, candidate in ipairs {
    project_file(root_dir, '.venv/bin/python'),
    project_file(root_dir, '.venv/bin/python3'),
  } do
    if executable(candidate) then
      return candidate
    end
  end

  if vim.env.VIRTUAL_ENV then
    local venv_python = vim.fs.joinpath(vim.env.VIRTUAL_ENV, 'bin/python')
    if executable(venv_python) then
      return venv_python
    end
  end

  if vim.fn.filereadable(project_file(root_dir, 'pyproject.toml')) == 1 and vim.fn.executable 'poetry' == 1 then
    local venv = vim.fn.trim(vim.fn.system { 'poetry', 'env', 'info', '--path' })
    local poetry_python = vim.fs.joinpath(venv, 'bin/python')
    if vim.v.shell_error == 0 and executable(poetry_python) then
      return poetry_python
    end
  end

  if vim.fn.filereadable(project_file(root_dir, 'Pipfile')) == 1 and vim.fn.executable 'pipenv' == 1 then
    local venv = vim.fn.trim(vim.fn.system { 'pipenv', '--venv' })
    local pipenv_python = vim.fs.joinpath(venv, 'bin/python')
    if vim.v.shell_error == 0 and executable(pipenv_python) then
      return pipenv_python
    end
  end

  return first_executable { 'python3', 'python' } or 'python3'
end

local function system_lines(cmd)
  local output = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    return {}
  end

  local lines = {}
  for line in output:gmatch '[^\r\n]+' do
    line = vim.fn.trim(line)
    if line ~= '' then
      table.insert(lines, line)
    end
  end

  return lines
end

local function get_extra_paths(root_dir, python_path)
  local paths = {}
  local seen = {}

  local function add_path(path)
    if path and path ~= '' and vim.fn.isdirectory(path) == 1 and not seen[path] then
      table.insert(paths, path)
      seen[path] = true
    end
  end

  if vim.fn.executable 'uv' == 1 then
    for _, path in ipairs(system_lines { 'uv', 'workspace', 'list', '--paths' }) do
      add_path(path)
      add_path(vim.fs.joinpath(path, 'src'))
    end
  end

  for _, path in ipairs(system_lines { python_path, '-c', "import sysconfig; print(sysconfig.get_path('purelib') or '')" }) do
    add_path(path)
  end

  for _, path in ipairs(system_lines { python_path, '-c', "import sys; print('\\n'.join(sys.path))" }) do
    if path:match 'site%-packages' or path:match 'lib/python' then
      add_path(path)
    end
  end

  add_path(root_dir or vim.fn.getcwd())
  return paths
end

return {
  {
    'williamboman/mason.nvim',
    opts = {},
  },

  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    opts = {
      ensure_installed = servers,
      automatic_enable = false,
    },
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/nvim-cmp',
    },
    config = function()
      local capabilities = require('utils.lsp_capabilities').get_capabilities()

      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        virtual_text = { source = 'if_many', spacing = 2 },
      }

      local on_attach = function(_, bufnr)
        local opts = { buffer = bufnr, silent = true }

        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = 'Go to definition' }))
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'LSP hover' }))
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = 'LSP rename' }))
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = 'LSP code action' }))
        vim.keymap.set('n', '<leader>f', function()
          vim.lsp.buf.format { async = true }
        end, vim.tbl_extend('force', opts, { desc = 'Format buffer' }))
      end

      vim.lsp.config('pyright', {
        on_attach = on_attach,
        capabilities = capabilities,
        before_init = function(_, config)
          local root_dir = config.root_dir or vim.fn.getcwd()
          local python_path = get_python_path(root_dir)

          config.settings = vim.tbl_deep_extend('force', config.settings or {}, {
            python = {
              pythonPath = python_path,
              analysis = {
                extraPaths = get_extra_paths(root_dir, python_path),
              },
            },
          })
        end,
        settings = {
          pyright = {
            disableLanguageServices = false,
            disableOrganizeImports = false,
          },
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = 'openFilesOnly',
              typeCheckingMode = 'basic',
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      vim.lsp.config('ruff', {
        on_attach = on_attach,
        capabilities = capabilities,
        init_options = {
          settings = {
            lint = { enabled = true, extendSelect = { 'I' } },
            format = { enabled = true },
          },
        },
      })

      vim.lsp.config('lua_ls', {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { 'vim' } },
            telemetry = { enable = false },
            workspace = {
              checkThirdParty = false,
              library = vim.api.nvim_get_runtime_file('', true),
            },
          },
        },
      })

      vim.lsp.enable(servers)
    end,
  },
}
