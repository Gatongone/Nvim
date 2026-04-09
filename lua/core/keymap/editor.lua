local map = require("core.keymap.map")
local editor         = nvim.keymap.editor
local move_length    = 10

-- Leader
vim.g.mapleader      = editor.leader
vim.g.maplocalleader = editor.leader

-- Unmap
map.nmap('s',                               '<nop>')
map.nmap('F',                               '<nop>')
map.nmap('gh',                              '<nop>')

-- Mode
map.nmap(editor.insert_mode,                'a')
map.nmap(editor.virtual_mode,               'v')
map.nmap(editor.virtual_block_mode,         '<C-q>')
map.imap(editor.normal_mode,                '<esc>')
map.vmap(editor.normal_mode,                '<esc>')

-- Arrow
map.nmap(editor.normal_up,                  'k')
map.nmap(editor.normal_down,                'j')
map.nmap(editor.normal_left,                'h')
map.nmap(editor.normal_right,               'l')
map.nmap(editor.normal_up_l,                move_length .. 'k')
map.nmap(editor.normal_down_l,              move_length .. 'j')
map.nmap(editor.normal_line_begin_insert,   'I')
map.nmap(editor.normal_line_end_insert,     'A')
map.nmap(editor.normal_line_end,            '$')
map.nmap(editor.normal_line_begin,          '^')
map.nmap(editor.normal_next_word_begin,     'e')
map.nmap(editor.normal_prev_word_begin,     'b')

map.vmap(editor.virtual_up,                 'k')
map.vmap(editor.virtual_down,               'j')
map.vmap(editor.virtual_left,               'h')
map.vmap(editor.virtual_right,              'l')
map.vmap(editor.virtual_up_l,               move_length .. 'k')
map.vmap(editor.virtual_down_l,             move_length .. 'j')
map.vmap(editor.virtual_next_word_begin,    'e')
map.vmap(editor.virtual_prev_word_begin,    'b')
map.vmap(editor.virtual_line_end,           '$h')
map.vmap(editor.virtual_line_begin,         '^')

-- Intent
map.nmap(editor.intent_left,                '<<')
map.nmap(editor.intent_right,               '>>')
map.vmap(editor.intent_left,                '<gv')
map.vmap(editor.intent_right,               '>gv')

-- Move
map.vmap(editor.virtual_move_up,            ":move '<-2<CR>gv-gv")
map.vmap(editor.virtual_move_down,          ":move '>+1<CR>gv-gv")

-- Goto
map.nmap(editor.goto,                       ":JumpWord<CR>")
map.nmap(editor.goback,                     "<C-o>")

-- Delete
map.nmap(editor.delete,                     'd')

-- Redo/Undo
map.nmap(editor.redo,                       '<C-r>')
map.nmap(editor.undo,                       'u')

-- Save
map.nmap(editor.save,                       ':w<CR>')

-- Select All
map.nmap(editor.select_all,                 'gg0vG$')
map.vmap(editor.select_all,                 'vgg0vG$')
map.nmap(editor.select_in,                  'vi')
map.vmap(editor.select_in,                  'i')

-- Copy/Cut/Paste
map.nmap(editor.copy,                       'y')
map.nmap(editor.cut,                        'x')

-- Record/Play
map.nmap(editor.record,                     'qa')
map.nmap(editor.play,                       '@a')

-- Commenting
map.nmap(editor.comment,  function() vim.cmd.norm('gcc') end)
map.vmap(editor.comment,  function() vim.cmd.norm('gc')  end)

-- Close tab or window
map.nmap(editor.close,                       ':q!<CR>')

-- Align
map.vmap(editor.align, function()
    vim.ui.input({ prompt = "Align " }, function(input)
        if input then
            if pcall(function() vim.cmd(string.format("silent! '<,'>Align %s", input)) end) then
                vim.cmd("stopinsert")
            end
        end
    end)
end)
