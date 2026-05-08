vim.pack.add({
  "https://github.com/hat0uma/csvview.nvim",
})

require("csvview").setup({
  parser = { comments = { '#', '//' } },
})

vim.keymap.set("n", "gcs", ":CsvViewToggle<CR>", { desc = "Toggle CSV View" })
