local map = require("core.keymap.map")
local ex = nvim.keymap.explore
local editor = nvim.keymap.editor

map.nmap(ex.open_explore, ":Ranger<CR>")

-- Convert nvim key to ranger key style
local function to_conf_key(key)
    if key == '<Leader>' then
        return '<Space>'
    end
    return key
end

-- Default keymaps see: https://github.com/ranger/ranger/blob/master/ranger/config/rc.conf
local custom_keymaps = string.format(
[[
set preview_images true
set collapse_preview true
set preview_files true
set preview_script true
set use_preview_script true

copymap <UP>       %s
copymap <DOWN>     %s
copymap <LEFT>     %s
copymap <RIGHT>    %s

map %s         edit
map %s         quit
map %s         change_mode normal
map %s         copy mode=toggle
map %s         cut mode=toggle
map %s         paste overwrite=True append=True
map %s         console touch#space
map %s         console mkdir#space
map %s         console rename#space
map %s         console delete 
map %s         tag_toggle
]],
to_conf_key(ex.move_to_prev_item),
to_conf_key(ex.move_to_next_item),
to_conf_key(ex.move_to_parent_folder),
to_conf_key(ex.move_to_current_folder),
to_conf_key(ex.edit),
to_conf_key(ex.close_explore),
to_conf_key(editor.normal_mode),
to_conf_key(ex.copy),
to_conf_key(ex.cut),
to_conf_key(ex.paste),
to_conf_key(ex.create_file),
to_conf_key(ex.create_directory),
to_conf_key(ex.rename),
to_conf_key(ex.delete),
to_conf_key(ex.mark_or_unmark))

return custom_keymaps:gsub([[#space]], [[%%space]])
