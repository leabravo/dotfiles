return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
        {
            "nvim-treesitter/nvim-treesitter-textobjects",
            config = function()
                require'nvim-treesitter.configs'.setup({
                    textobjects = {
                        select = {
                          enable = true,

                          -- Automatically jump forward to textobj, similar to targets.vim
                          lookahead = true,

                          keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            -- You can optionally set descriptions to the mappings (used in the desc parameter of
                            -- nvim_buf_set_keymap) which plugins like which-key display
                            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                            -- You can also use captures from other query groups like `locals.scm`
                            ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
                          },
                          selection_modes = {
                            ['@parameter.outer'] = 'v', -- charwise
                            ['@function.outer'] = 'V', -- linewise
                            ['@class.outer'] = '<c-v>', -- blockwise
                          },
                          include_surrounding_whitespace = false,
                        },
                      },
                  })
            end
        },
    },
    config = function()
        require'nvim-treesitter.configs'.setup {
          -- A list of parser names, or "all" (the five listed parsers should always be installed)
          ensure_installed = { "go", "gomod", "python", "lua", "vim", "vimdoc", "markdown" },

          -- Install parsers synchronously (only applied to `ensure_installed`)
          sync_install = false,

          -- Automatically install missing parsers when entering buffer
          -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
          auto_install = true,

          highlight = {
            enable = true,

            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            additional_vim_regex_highlighting = false,
          },
        }
    end
}
