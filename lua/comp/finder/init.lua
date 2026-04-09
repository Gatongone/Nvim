local config = require("config")
local finder = config.setting.editor.finder
if finder == "fzf" and vim.fn.executable("fzf") then
    require("comp.finder.fzf")
end
