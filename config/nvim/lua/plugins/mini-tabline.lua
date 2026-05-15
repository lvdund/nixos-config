vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

require("mini.tabline").setup({
  show_icons = true,
  format = nil,
  tabpage_section = "left",
})
