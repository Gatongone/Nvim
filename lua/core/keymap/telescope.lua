local map = require("core.keymap.map")
local finder = nvim.keymap.finder
local editor = nvim.keymap.editor
local action = require('telescope.actions')

if nvim.setting.editor.finder == "telescope" then
    map.nmap(nvim.keymap.finder.open_finder, ":Telescope<CR>")
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
