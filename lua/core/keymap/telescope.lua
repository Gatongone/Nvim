local map = require("core.keymap.map")
local config = require("config")
local finder = config.keymap.finder
local editor = config.keymap.editor
local action = require('telescope.actions')

if config.setting.editor.finder == "telescope" then
    map.nmap(config.keymap.finder.open_finder, ":Telescope<CR>")
end

return
{
    i =
    {
        ["<Tab>"]                 = action.toggle_selection,
        [finder.finder_move_up]   = action.move_selection_previous,
        [finder.finder_move_down] = action.move_selection_next,
        [finder.finder_enter]     = action.select_default,
        [editor.close]            = action.close,
    },
    n =
    {
        ["<Esc>"]                 = action.nop,
        ["<Space>"]               = action.toggle_selection,
        ["<Tab>"]                 = action.toggle_selection,
        [editor.normal_up]        = action.move_selection_previous,
        [editor.normal_down]      = action.move_selection_next,
        [editor.normal_right]     = action.select_default,
        [editor.close]            = action.close,
    }
}
