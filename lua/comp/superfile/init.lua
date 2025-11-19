local ex = require("comp.exex")
function ex.get_cmd(tempfile)
    return string.format('spf %s --chooser-file=%s', vim.fn.expand('%:p:h'), tempfile)
end
ex.custom_keymaps = require("core.keymap.superfile")
ex.keymap_path    = vim.fn.expand("~/.config/superfile/hotkeys.toml")
ex.use_vim_map    = vim.fn.filereadable(ex.keymap_path) == 0
vim.api.nvim_create_user_command("Spf",  ex.open_explore, { })
