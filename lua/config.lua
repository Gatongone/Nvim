--- Keymap
nvim.keymap =
{
    editor =
    {
        leader                   = ' ',                -- Key for <Leader>.

        intent_left              = '<C-j>',            -- Append a tab intent to the line beginning in virtual mode and normal mode.
        intent_right             = '<C-l>',            -- Remove a tab intent to the line beginning in virtual mode and normal mode.

        insert_mode              = '<esc>',            -- Enter insert mode.

        normal_mode              = '<esc>',            -- Enter normal mode.
        normal_up                = 'i',                -- Move cursor to previous line in normal mode.
        normal_down              = 'k',                -- Move cursor to next line in normal mode.
        normal_left              = 'j',                -- Move cursor to previous character in normal mode.
        normal_right             = 'l',                -- Move cursor to next character in normal mode.
        normal_up_l              = 'I',                -- Move cursor to previous 10 line in normal mode.
        normal_down_l            = 'K',                -- Move cursor to next 10 line in normal mode.
        normal_line_begin_insert = 'q',                -- Move cursor to the line beginning in normal mode and then enter virtual mode.
        normal_line_end_insert   = 'e',                -- Move cursor to the line ending in virtual mode and then enter virtual mode.
        normal_line_begin        = 'J',                -- Move cursor to the line beginning in normal mode and then enter virtual mode.
        normal_line_end          = 'L',                -- Move cursor to the line ending in virtual mode and then enter virtual mode.
        normal_next_word_begin   = 'w',                -- Move cursor to next word beginning in normal mode.
        normal_prev_word_begin   = 'W',                -- Move cursor to previous word beginning in normal mode.

        virtual_mode             = 'v',                -- Enter virtual mode.
        virtual_block_mode       = 'b',                -- Enter block mode.
        virtual_up               = 'i',                -- Move cursor to previous line in virtual mode.
        virtual_down             = 'k',                -- Move cursor to next line in virtual mode.
        virtual_left             = 'j',                -- Move cursor to previous character in virtual mode.
        virtual_right            = 'l',                -- Move cursor to next character in virtual mode.
        virtual_up_l             = 'I',                -- Move cursor to previous 10 line in virtual mode.
        virtual_down_l           = 'K',                -- Move cursor to next 10 line in virtual mode.
        virtual_line_begin       = 'J',                -- Move cursor to the line beginning in virtual mode.
        virtual_line_end         = 'L',                -- Move cursor to the line ending in virtual mode.
        virtual_move_up          = '<A-i>',            -- Move selected text to previous line in virtual mode.
        virtual_move_down        = '<A-k>',            -- Move selected text to next line in virtual mode.
        virtual_next_word_begin  = 'w',                -- Move cursor to next word beginning in normal mode.
        virtual_prev_word_begin  = 'W',                -- Move cursor to previous word beginning in normal mode.

        select_all               = 'sa',               -- Enter virtual mode and select all.
        select_in                = 'si',               -- Enter virtual mode and select in target.

        translate                = 'ts',               -- Translate selected words or sentence.

        delete                   = 'd',                -- Delete with option.
        undo                     = 'u',                -- Undo operation.
        redo                     = 'U',                -- Redo operation.
        save                     = '<C-s>',            -- Save file.
        copy                     = 'y',                -- Copy text with options.
        cut                      = 'x',                -- Cut text.
        paste                    = 'p',                -- Paste text to the right of cursor.
        record                   = 'h',                -- Recording.
        play                     = 'H',                -- Play records.
        goback                   = 'gb',               -- Go back to previous edited position.
        goto                     = 'gt',               -- Go to everywhere.
        comment                  = '<C-_>',            -- Commenting lines.
        close                    = '<C-q>'             -- Forced to close Tab or window.
    },
    tab =
    {
        prev_tab                 = '<A-q>',            -- Set the left tab as current.
        next_tab                 = '<A-e>',            -- Set the right tab as current.
    },
    win =
    {
        focus_left_win           = '<A-j>',            -- Focus on the window on the left.
        focus_right_win          = '<A-l>',            -- Focus on the window on the right.
        focus_up_win             = '<A-i>',            -- Focus on the window above.
        focus_down_win           = '<A-k>',            -- Focus on the window below.
        resize_vwin_bigger       = '<Leader>l',        -- Make the window bigger vertically (Increase window width).
        resize_vwin_smaller      = '<Leader>j',        -- Make the window smaller vertically (Decrease window width).
        resize_hwin_bigger       = '<Leader>i',        -- Make the window bigger horizontally (Increase window height).
        resize_hwin_smaller      = '<Leader>k',        -- Make the window smaller horizontally (Decrease window height).
    },
    finder =
    {
        open_finder              = '<Leader><Leader>', -- Find everything.
        finder_move_up           = '<A-i>',            -- Finder cursor move up.
        finder_move_down         = '<A-k>',            -- Finder cursor move down.
        finder_enter             = '<A-l>',            -- Finder enter item.
    },
    terminal =
    {
        open_terminal            = 'tt',               -- Open the terminal in a float window.
        open_terminal_horizontal = 'th',               -- Open the terminal in a horizontally split window.
        open_terminal_vertical   = 'tv',               -- Open the terminal in a vertically split window.
    },
    explore =                                          -- When using explore utilities (e.g. yazi, ranger, etc.), it will only take effect, when their respective configuration files are missing.
    {
        open_explore             = '<A-f>',            -- Open explore.
        close_explore            = '<A-f>',            -- Close explore.

        move_to_prev_item        = 'i',                -- Select previous item.
        move_to_next_item        = 'k',                -- Select next item.
        move_to_parent_folder    = 'j',                -- Go back to parent directory.
        open                     = 'l',                -- Open a file with nvim or enter the directory.

        create_file              = 'nf',               -- Create a file to current directory.
        create_directory         = 'nd',               -- Create a directory to current directory.
        rename                   = 'r',                -- Rename file or directory name.
        delete                   = 'd',                -- Delete current selected item or marked items.
        copy                     = 'y',                -- Set or remove the file or directory in the copied buffer.
        cut                      = 'x',                -- Set or delete the file or directory in the cut buffer.
        paste                    = 'p',                -- Push copied and cut buffer's items to current directory.

        mark_or_unmark           = '<Leader>',         -- Toggle mark item.
    },
    lsp =
    {
        format_code              = '<C-f>',            -- Apply formatting.
        rename_buf               = '<C-r>',            -- Rename buffer variable.
        open_hover_doc           = '<C-d>',            -- Open hover document.
        open_error_diag          = '<C-e>',            -- Open buffer error diagnostic.
        open_code_action         = '<C-a>',            -- Open code action.

        goto_definition          = 'gd',               -- Go to definition.
        goto_implementation      = 'gi',               -- Go to implementation.
        goto_declaration         = 'gD',               -- Go to declaration.
        goto_ref                 = 'gr',               -- Go to references.
        goto_prev_diag           = 'gj',               -- Go to previous diagnostic item.
        goto_next_diag           = 'gl',               -- Go to next diagnostic item.

        cmp_prev                 = '<A-i>',            -- Go to previous cmp item.
        cmp_next                 = '<A-k>',            -- Go to previous cmp item.
        cmp_abort                = '<A-j>',            -- Abort cmp.
        cmp_complete             = '<A-l>',            -- Complete cmp suggestion.
        cmp_confirm              = '<Tab>',            -- Confirm cmp item.
        cmp_doc_scroll_up        = '<C-i>',            -- Cmp document scroll up.
        cmp_doc_scroll_down      = '<C-k>',            -- Cmp document scroll down.

        dap_continue             = '<Leader>`',        -- Continue.
        dap_breakpoint           = '<Leader>d',        -- Toggle breakpoint.
        dap_stepover             = '<Leader>1',        -- Step over.
        dap_stepinto             = '<Leader>2',        -- Step into.
        dap_stepout              = '<Leader>3',        -- Step out.
    }
}

--- Settings
nvim.setting =
{
    editor =
    {
        explore                  = 'netrw',            -- Explore implementation, advanced 'netrw' for default. 'yazi', 'ranger', 'superfile' are builtin supported.
        finder                   = 'fzf',              -- Finder implementation, 'fzf', 'telescope' are builtin supported.
        git                      = 'lazygit',          -- Git TUI implementation, 'lazygit', 'gitui' are builtin supported.
    },
    file =
    {
        encoding                 = 'utf-8',            -- File default encoding.
        tab_intent               = false,              -- 'True' for tab intent, and 'False' for whitespace intent.
        intent_num               = 4,                  -- Intent number.
    },
    appearance =
    {
        theme                  = 'popnlock',           -- Neovim theme, 'none' for default, theme files will be collected to 'nvim/lua/theme/scheme'.
        fill_char              = ' ',                  -- Characters to fill the statuslines, vertical separators and special lines in the window.
        show_line_number       = true,                 -- Enable line number.
        relative_line_number   = false,                -- Enable relative line number (This option will only take effect when 'show_line_number' is true).
        highlight_line         = false,                -- Enable the highlight for the line where cursor located.
        transparent_background = true,                 -- Remove all background colors.
    },
}
