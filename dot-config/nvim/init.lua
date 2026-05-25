local site_path = vim.fn.stdpath("data") .. "/site/"
vim.opt.runtimepath:prepend(site_path)

-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require('plugins')
require('settings')
require('lsp')

