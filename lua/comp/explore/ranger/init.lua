local ex = require("comp.explore.exex")
function ex.get_cmd(tempfile)
    return string.format('ranger --choosefile=%s', tempfile)
end
ex.custom_keymaps = require("core.keymap.ranger")
ex.keymap_path    = vim.fn.expand("~/.config/ranger/rc.conf")
ex.use_vim_map    = vim.fn.filereadable(ex.keymap_path) == 0
vim.api.nvim_create_user_command("Ranger",  ex.open_explore, { })
