local servers = require("comp.lsp.servers")
for name, server in pairs(servers) do
    vim.lsp.config[name] = server
    vim.lsp.enable(name)
end

vim.diagnostic.config(
{
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
