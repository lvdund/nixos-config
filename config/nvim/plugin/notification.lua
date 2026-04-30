vim.pack.add({
  "https://github.com/rcarriga/nvim-notify",
})

require("notify").setup({
  render = "wrapped-compact",
  stages = "fade_in_slide_out",
  timeout = 100,
})
