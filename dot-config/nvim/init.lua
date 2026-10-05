-- Disable netrw at the start
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local site_path = vim.fn.stdpath("data") .. "/site/"
vim.opt.runtimepath:prepend(site_path)

-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require('plugins')
require('settings')
require('lsp')
