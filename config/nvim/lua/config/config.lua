vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.o.number = true
vim.opt.relativenumber = true
vim.o.mouse = 'a'
vim.o.showmode = true
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 500
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.opt.colorcolumn = '90'
vim.o.inccommand = 'split'
vim.o.scrolloff = 3
vim.o.confirm = false
vim.o.winborder = 'rounded'
vim.opt.termguicolors = true
vim.opt.signcolumn = 'auto'
vim.opt.wrap = true

-- ignore: fuzz, grep
vim.opt.wildignore:append '**/node_modules/*'
vim.opt.wildignore:append '**/package-lock.json'
