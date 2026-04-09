local M = {}
local parse     = require("comp.explore.netrw.parser")
local kind_icon = require("theme.icon").kind

local get_icon = function(node)
    local icon = ""
    local hl_group = ""
    local has_miniicons, miniicons = pcall(require, "mini.icons")
    local has_devicons, devicons = pcall(require, "nvim-web-devicons")

    if has_miniicons then
        local ic, hi = miniicons.get("file", node.node)
        if ic then
            icon = ic
            hl_group = hi
            end
    elseif has_devicons then
        local ic, hi = devicons.get_icon(node.node, nil, { strict = true, default = false })
        if ic then
            icon = ic
            hl_group = hi
        end
    end
    if icon == "" then
        if node.type == parse.TYPE_DIR then
            icon = kind_icon.folder
            hl_group = "NetrwDirectory"
        elseif node.type == parse.TYPE_SYMLINK then
            icon = kind_icon.link
            hl_group = "NetrwLink"
        else
            icon = kind_icon.file
            hl_group = "NetrwFile"
        end
    end

    return { icon, hl_group }
end

M.setup = function(bufnr)
    local namespace = vim.api.nvim_create_namespace("netrw")

    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    for i, line in ipairs(lines) do
        local node = parse.get_node(line)
        if not node then
            goto continue
        end

        local opts = { id = i }
        local icon, hl_group = unpack(get_icon(node))
        if node.col == 0 then
            if hl_group then
                opts.sign_hl_group = hl_group
            end
            opts.sign_text = icon
            vim.api.nvim_buf_set_extmark(bufnr, namespace, i - 1, 0, opts)
        else
            if hl_group then
                opts.virt_text = { { icon, hl_group } }
            else
                opts.virt_text = { { icon } }
            end
            opts.virt_text_pos = "overlay"
            vim.api.nvim_buf_set_extmark(bufnr, namespace, i - 1, node.col - 2, opts)
        end
        ::continue::
    end
end

return M
