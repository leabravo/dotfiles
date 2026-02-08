require('config.render_markdown')
require('config.nvim_web_devicons')
require('config.zk_nvim')
require('config.catppuccin')
require('config.nvim_tree')
require('config.lualine')

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

vim.cmd.colorscheme "catppuccin"

-- Do not pick the first option automatically
vim.opt.completeopt = "menuone,noselect,popup,fuzzy"

-- Line Numbers
vim.opt.number = true            -- Show current line number
vim.opt.relativenumber = true    -- Relative numbers for fast jumping

-- 80 Character Limit & Wrapping
vim.opt.colorcolumn = "80"       -- Vertical ruler at 80 chars
vim.opt.textwidth = 80           -- Hard wrap at 80 (optional, remove if annoying)
vim.opt.wrap = false             -- Don't soft wrap lines

-- Indentation
vim.opt.expandtab = true         -- Use spaces instead of tabs
vim.opt.shiftwidth = 4           -- Size of an indent
vim.opt.tabstop = 4              -- Number of spaces tabs count for
vim.opt.smartindent = true       -- Insert indents automatically

-- Search
vim.opt.ignorecase = true        -- Ignore case in search patterns
vim.opt.smartcase = true         -- Override ignorecase if search has caps
vim.opt.incsearch = true         -- Show search results as you type [neovim.io](https://neovim.io)

-- UI & Performance
vim.opt.termguicolors = true     -- True color support
vim.opt.cursorline = true        -- Highlight the text line under the cursor
vim.opt.scrolloff = 8            -- Lines of context when scrolling
vim.opt.signcolumn = "yes"       -- Always show the sign column (prevents flickering)

-- System Integration
vim.opt.clipboard = "unnamedplus" -- Sync with system clipboard
vim.opt.undofile = true           -- Save undo history to a file [vimhelp.org](https://vimhelp.org)
vim.opt.updatetime = 250          -- Faster completion and UI response
