local ex = require("comp.exex")
function ex.get_cmd(tempfile)
    return string.format('yazi %s --chooser-file="%s"', vim.fn.expand('%:p:h'), tempfile)
end
ex.custom_keymaps = require("core.keymap.yazi")
ex.keymap_path    = vim.fn.expand("~/.config/yazi/keymap.toml")
ex.use_vim_map    = vim.fn.filereadable(ex.keymap_path) == 0
vim.api.nvim_create_user_command("Yazi",  ex.open_explore, { })
