local map = require("core.keymap.map")
local config = require("config")
map.vmap(config.keymap.editor.translate, function() vim.cmd("Translate") end)
