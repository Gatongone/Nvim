-- Require lazy from github
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local ext = require("util.ext")
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system(
        {
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable",
            lazypath,
        })
end
vim.opt.rtp:prepend(lazypath)

-- Setup plugins
require("lazy").setup("plug.lazy")

-- Setup ui keymaps
local configs               = require("lazy.view.config")
local commands              = configs.commands
local keys                  = configs.keys
keys.hover                  = "h"
commands.install.key        = "O"
commands.install.key_plugin = "o"

-- Reset window style
vim.api.nvim_create_autocmd("FileType",
{
    pattern = "lazy",
    callback = function()
        local win          = vim.api.nvim_get_current_win()
        local opts         = vim.api.nvim_win_get_config(win)
        local default_opts = ext.win.get_win_config({ title = "Plugins" })
        opts.title         = default_opts.title
        opts.title_pos     = default_opts.title_pos
        opts.border        = default_opts.border
        opts.width         = default_opts.width
        opts.height        = default_opts.height
        opts.col           = default_opts.col
        opts.row           = default_opts.row
        vim.api.nvim_win_set_config(win, opts)
    end
})
