local editor         = nvim.keymap.editor
local move_length    = 10

-- Leader
vim.g.mapleader      = editor.leader
vim.g.maplocalleader = editor.leader

-- Unmap
nmap('s',                               '<nop>')
nmap('F',                               '<nop>')
nmap('gh',                              '<nop>')

-- Mode
nmap(editor.insert_mode,                'a')
nmap(editor.virtual_mode,               'v')
nmap(editor.virtual_block_mode,         '<C-q>')
imap(editor.normal_mode,                '<esc>')
vmap(editor.normal_mode,                '<esc>')

-- Arrow
nmap(editor.normal_up,                  'k')
nmap(editor.normal_down,                'j')
nmap(editor.normal_left,                'h')
nmap(editor.normal_right,               'l')
nmap(editor.normal_up_l,                move_length .. 'k')
nmap(editor.normal_down_l,              move_length .. 'j')
nmap(editor.normal_line_begin_insert,   'I')
nmap(editor.normal_line_end_insert,     'A')
nmap(editor.normal_line_end,            '$')
nmap(editor.normal_line_begin,          '^')
nmap(editor.normal_next_word_begin,     'e')
nmap(editor.normal_prev_word_begin,     'b')

vmap(editor.virtual_up,                 'k')
vmap(editor.virtual_down,               'j')
vmap(editor.virtual_left,               'h')
vmap(editor.virtual_right,              'l')
vmap(editor.virtual_up_l,               move_length .. 'k')
vmap(editor.virtual_down_l,             move_length .. 'j')
vmap(editor.virtual_next_word_begin,    'e')
vmap(editor.virtual_prev_word_begin,    'b')
vmap(editor.virtual_line_end,           '$h')
vmap(editor.virtual_line_begin,         '^')

-- Intent
nmap(editor.intent_left,                '<<')
nmap(editor.intent_right,               '>>')
vmap(editor.intent_left,                '<gv')
vmap(editor.intent_right,               '>gv')

-- Move
vmap(editor.virtual_move_up,            ":move '<-2<CR>gv-gv")
vmap(editor.virtual_move_down,          ":move '>+1<CR>gv-gv")

-- Goto
nmap(editor.goto,                       ":JumpWord<CR>")
nmap(editor.goback,                     "<C-o>")

-- Delete
nmap(editor.delete,                     'd')

-- Redo/Undo
nmap(editor.redo,                       '<C-r>')
nmap(editor.undo,                       'u')

-- Save
nmap(editor.save,                       ':w<CR>')

-- Select All
nmap(editor.select_all,                 'gg0vG$')
vmap(editor.select_all,                 'vgg0vG$')
nmap(editor.select_in,                  'vi')
vmap(editor.select_in,                  'i')

-- Copy/Cut/Paste
nmap(editor.copy,                       'y')
nmap(editor.copy,                       'y')
nmap(editor.cut,                        'x')

-- Record/Play
nmap(editor.record,                     'qa')
nmap(editor.play,                       '@a')

-- Commenting
nmap(editor.comment,  function() vim.cmd.norm('gcc') end)
vmap(editor.comment,  function() vim.cmd.norm('gc')  end)

-- Close tab or window
nmap(editor.close,                       ':q!<CR>')

-- Align
vmap(editor.align, function()
    vim.ui.input({ prompt = "Align " }, function(input)
        if input then
            if pcall(function() vim.cmd(string.format("silent! '<,'>Align %s", input)) end) then
                vim.cmd("stopinsert")
            end
        end
    end)
end)
