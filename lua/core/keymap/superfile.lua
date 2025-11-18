local ex = nvim.keymap.explore
local editor = nvim.keymap.editor

nmap(ex.open_explore, ":Spf<CR>")

-- Convert nvim key to superfile key style
local function to_toml_key(key)

    if key:sub(1,3) == "<A-" then
        return "alt-"..key:sub(4,4)
    elseif key:sub(1,3) == "<C-" then
        return "ctrl-"..key:sub(4,4)
    elseif key == '<Leader>' then
        return "space"
    elseif key == "<Tab>" then
        return "tab"
    elseif key == "<Esc>" then
        return "esc"
    elseif key == "<CR>" or key == "<cr>" then
        return "enter"
    else
        return ""
    end
end

-- Default keymaps see: https://superfile.dev/configure/custom-hotkeys/
local custom_keymaps = string.format(
[[
confirm = ['enter', 'right', '%s']
cancel_typing = ['ctrl+c', '%s']
quit = ['%s']
list_up = ['up', '%s']
list_down = ['down', '%s']
parent_directory = ['%s', 'left', 'backspace']
copy_items = ['ctrl+c', '%s']
cut_items = ['ctrl+x', '%s']
paste_items = ['ctrl+v', 'ctrl+w', '%s']
create_new_file_panel = ['n', '%s']
file_panel_item_rename = ['ctrl+r', '%s']
delete_items = ['ctrl+d', 'delete', '%s']
file_panel_select_mode_items_select_down = ['%s', '%s']
file_panel_select_mode_items_select_up = ['%s']
file_panel_select_all_items = ['']
]],
to_toml_key(ex.open),
to_toml_key(editor.normal_mode),
to_toml_key(ex.close_explore),
to_toml_key(ex.move_to_prev_item),
to_toml_key(ex.move_to_next_item),
to_toml_key(ex.move_to_parent_folder),
to_toml_key(ex.copy),
to_toml_key(ex.cut),
to_toml_key(ex.paste),
to_toml_key(ex.create_file),
to_toml_key(ex.rename),
to_toml_key(ex.delete),
to_toml_key(ex.mark_or_unmark),
to_toml_key(editor.normal_down_l),
to_toml_key(editor.normal_up_l),
to_toml_key(editor.select_all))

return custom_keymaps
