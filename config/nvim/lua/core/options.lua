vim.o.relativenumber = true
vim.o.number = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.confirm = true
vim.o.signcolumn = "yes"
vim.o.ttimeoutlen = 1
vim.o.scrolloff = 3

vim.opt.colorcolumn = "80"
vim.opt.textwidth = 80

vim.opt.wildignore:append("**/node_modules/*")
vim.opt.wildignore:append("**/package-lock.json")
vim.opt.fillchars:append({ eob = " " })

vim.schedule(function()
  vim.o.clipboard = "unnamedplus"
end)

require("vim._core.ui2").enable({
  enable = true,
  msg = {
    target = "cmd",
    pager = { height = 1 },
    msg = { height = 1, width = 1, timeout = 2000 },
    dialog = { height = 0.5 },
    cmd = { height = 0.5 },
  },
})

vim.diagnostic.config({
  severity_sort = true,
  update_in_insert = false,
  float = { source = "if_many" },
  jump = { on_jump = true },
})
