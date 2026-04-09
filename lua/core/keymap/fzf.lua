local map = require("core.keymap.map")
local config = require("config")
local finder = config.keymap.finder
local editor = config.keymap.editor
local function convert_fzf_key(key)
    if key:sub(1,3) == "<A-" then
        return "alt-"..key:sub(4,4)
    elseif key:sub(1,3) == "<C-" then
        return "ctrl-"..key:sub(4,4)
    elseif key == "<Tab>" then
        return "tab"
    elseif key == "<Esc>" then
        return "esc"
    elseif key == "<CR>" or key == "<cr>" then
        return "enter"
    end
    return key
end

map.nmap(finder.open_finder, ":Fzf<CR>")
local keymaps = " --bind ".."ctrl-g:'jump' \\\n"
keymaps = keymaps.." --bind "..convert_fzf_key(finder.finder_move_up)..":'up' \\\n"
keymaps = keymaps.." --bind "..convert_fzf_key(finder.finder_move_down)..":'down' \\\n"
keymaps = keymaps.." --bind "..convert_fzf_key(finder.finder_enter)..":'accept' \\\n"
keymaps = keymaps.." --bind ".."ctrl-a"..":'select-all' \\\n"
keymaps = keymaps.." --bind ".."ctrl-"..editor.normal_up..":'last' \\\n"
keymaps = keymaps.." --bind ".."ctrl-"..editor.normal_down..":'first' \\\n"
return keymaps
