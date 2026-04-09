local file = require("config").setting.file

-- Indent
vim.o.tabstop      = file.indent_num
vim.bo.tabstop     = file.indent_num
vim.o.softtabstop  = file.indent_num
vim.o.shiftwidth   = file.indent_num
if file.tab_indent == false then
    vim.o.expandtab    = true
    vim.bo.expandtab   = true
end
vim.o.shiftround   = true
vim.o.autoindent   = true
vim.bo.autoindent  = true
vim.o.smartindent  = true

-- Search
vim.o.hlsearch     = true
vim.o.incsearch    = true
vim.o.ignorecase   = true
vim.o.smartcase    = true

-- Complete
vim.o.wildmenu     = true

-- Auto Read
vim.o.autoread     = true
vim.bo.autoread    = true

-- Encoding
vim.g.encoding     = file.encoding
vim.o.fileencoding = file.encoding
