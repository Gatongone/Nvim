local ex = nvim.keymap.explore
local editor = nvim.keymap.editor

nmap(ex.open_explore, ":Yazi<CR>")

-- Convert nvim key to yazi key style
local function to_toml_key(key)
    if key == '<Leader>' then
        return '"<Space>"'
    end
    if #key > 2 and string.sub(key,1,1) ~= '<' and string.sub(key, #key, #key) ~= '>' then
        local result = ''
        for char in key:gmatch(".") do
            result = result..'"'..char..'"'..','
        end
        return "[" .. string.sub(result, 1, string.len(result) - 1) .. "]"
    end
    return '"' .. key .. '"'
end

-- Default keymaps see: https://github.com/sxyazi/yazi/blob/shipped/yazi-config/preset/keymap-default.toml
local custom_keymaps = string.format(
[[
[manager]
keymap = [

    { on = %s,                 run = "open",                          desc = "enter" },
    { on = %s,                 run = "enter",                          desc = "Enter the child directory" },
    { on = %s,                 run = "escape",                        desc = "Exit visual mode, clear selected, or cancel search" },
    { on = %s,                 run = "quit",                          desc = "Quit the process" },
    { on = %s,                 run = "arrow -1",                      desc = "Move cursor up" },
    { on = %s,                 run = "arrow 1",                       desc = "Move cursor down" },
    { on = %s,                 run = "leave",                         desc = "Go back to the parent directory" },
    { on = %s,                 run = "yank",                          desc = "Yank selected files (copy)" },
    { on = %s,                 run = "yank --cut",                    desc = "Yank selected files (cut)" },
    { on = %s,                 run = "paste",                         desc = "Paste yanked files" },
    { on = %s,                 run = "create",                        desc = "Create a file (ends with / for directories)" },
    { on = %s,                 run = "rename --cursor=before_ext",    desc = "Rename selected file(s)" },
    { on = %s,                 run = "remove --permanently",          desc = "Permanently delete selected files" },
    { on = %s,                 run = [ "toggle" ],                    desc = "Toggle the current selection state" },
    { on = "o",                run = "open",                          desc = "Open file" },
    { on = [ "g", "g" ],       run = "arrow -99999999",               desc = "Move cursor to the top" },
    { on = "G",                run = "arrow 99999999",                desc = "Move cursor to the bottom" },
    { on = [ "c", "c" ],       run = "copy path",                     desc = "Copy the file path" },
    { on = [ "c", "d" ],       run = "copy dirname",                  desc = "Copy the directory path" },
    { on = [ "c", "f" ],       run = "copy filename",                 desc = "Copy the filename" },
    { on = [ "c", "n" ],       run = "copy name_without_ext",         desc = "Copy the filename without extension" },
    { on = [ "g", "h" ],       run = "cd ~",                          desc = "Go home" },
    { on = [ "g", "c" ],       run = "cd ~/.config",                  desc = "Goto ~/.config" },
    { on = [ "g", "d" ],       run = "cd ~/Downloads",                desc = "Goto ~/Downloads" },
    { on = [ "g", "<Space>" ], run = "cd --interactive",              desc = "Jump interactively" },
    { on = "/",                run = "find --smart",                  desc = "Find next file" },
    { on = "f",                run = "filter --smart",                desc = "Filter files" },
]
]],
to_toml_key(ex.move_to_current_folder),
to_toml_key(ex.edit),
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
to_toml_key(ex.mark_or_unmark))

return custom_keymaps
