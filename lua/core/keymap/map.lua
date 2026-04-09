local map  = vim.keymap.set
local opts  = {noremap = true, silent = true}
local function merge(t1, t2)
    local result = {}
    if t1 then
        for k, v in pairs(t1) do
            result[k] = v
        end
    end
    if t2 then
        for k, v in pairs(t2) do
            result[k] = v
        end
    end
    return result
end
return
{
    bnmap = function(before, after)
        vim.cmd("nnoremap <silent><buffer> ".. before .. " " .. after)
    end,
    bvmap = function(before, after)
        vim.cmd("vnoremap <silent><buffer> ".. before .. " " .. after)
    end,
    nmap = function(before, after, options)
        map('n',before, after, merge(opts, options))
    end,
    imap = function(before, after, options)
        map('i',before, after, merge(opts, options))
    end,
    vmap = function(before, after, options)
        map('v',before, after, merge(opts, options))
    end,
    tmap = function(before, after, options)
        map('t',before, after, merge(opts, options))
    end,
    xmap = function(before, after, options)
        map('x',before, after, merge(opts, options))
    end
}
