vim.pack.add({
  { src = "https://github.com/bluz71/vim-moonfly-colors", name = "moonfly" },
})

-- Lua initialization file
vim.cmd [[colorscheme moonfly]]

vim.g.moonflyItalics = true
vim.o.pumborder = "single"
vim.g.moonflyWinSeparator = 2
