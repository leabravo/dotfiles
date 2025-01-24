return {
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            { 'neovim/nvim-lspconfig' },
            {
                'williamboman/mason.nvim',
                config = function()
                    require('mason').setup()
                end
            },
        },
        config = function()
            require('mason-lspconfig').setup({
                ensure_installed = {"gopls", "pyright", "lua_ls"},
                handlers = {
                    function(server_name)
                        local capabilities = require('cmp_nvim_lsp').default_capabilities()
                        require('lspconfig')[server_name].setup({
                            capabilities = capabilities,
                        })
                    end,
                },
            })
        end
    },
}
