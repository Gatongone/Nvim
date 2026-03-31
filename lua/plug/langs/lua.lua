return
{
    lsp =
    {
        on_init = function(client)
            if client.workspace_folders and #client.workspace_folders > 0 then
                local path = client.workspace_folders[1].name
                local uv = vim.uv or vim.loop
                if uv.fs_stat(path .. '/.luarc.json') or uv.fs_stat(path .. '/.luarc.jsonc') then
                    return
                end
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua,
            {
                runtime =
                {
                    version = 'LuaJIT'
                },
                workspace =
                {
                    checkThirdParty = false,
                    library =
                    {
                        vim.env.VIMRUNTIME
                    }
                }
            })
        end,
        settings = { Lua = {} }
    }
}
