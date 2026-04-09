local map = require("core.keymap.map")
map.vmap(nvim.keymap.editor.translate, function() vim.cmd("Translate") end)
