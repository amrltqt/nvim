-- lua/utils/lsp_capabilities.lua
local M = {}

function M.get_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok, cmp_lsp = pcall(require, 'cmp_nvim_lsp')

  if ok then
    return cmp_lsp.default_capabilities(capabilities)
  end

  return capabilities
end

return M
