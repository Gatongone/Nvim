local config = require("config")
local appearance = config.setting.appearance

-- Theme
vim.o.background = "dark"
if appearance.theme == "none" then
    vim.o.termguicolors = false
    vim.cmd
    [[
        set cursorline
        highlight CursorLine ctermbg=7
        highlight Cursor ctermbg=7
    ]]
else
    require("theme").setup(appearance.theme)
end

if appearance.transparent_background == true then
    local transparent = require('comp.transparent')
    transparent.setup()
    transparent.toggle(true)
end

-- Line
vim.wo.number          = appearance.show_line_number
vim.wo.relativenumber  = appearance.relative_line_number
vim.wo.cursorline      = appearance.highlight_line

-- Fill characters
vim.opt.fillchars:append { eob = " " }

-- Cursor
vim.cmd [[set guicursor+=a:Cursor/lCursor]]

