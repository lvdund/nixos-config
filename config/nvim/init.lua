vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "nvim-treesitter" and kind == "update" then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})

vim.o.relativenumber = true
vim.o.number = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.confirm = true
vim.o.signcolumn = "yes"
vim.o.ttimeoutlen = 1
vim.o.scrolloff = 3

vim.schedule(function()
  vim.o.clipboard = "unnamedplus"
end)

require("configs.config")
require("configs.indent")
require("configs.keymaps")
require("configs.scroll")
require("configs.buffer")
require("configs.rejump")
require("configs.terminal")

require("vim._core.ui2").enable({
  enable = true,
  msg = {
    target = "cmd",
    pager = { height = 1 },
    msg = { height = 0.5, timeout = 4500 },
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


vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
