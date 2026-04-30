vim.pack.add({
	"https://github.com/esmuellert/codediff.nvim",
})

require("codediff").setup({})

vim.keymap.set("n", "<leader>ru", "<cmd>CodeDiff<cr>", { desc = "Code diff not staged" })
vim.keymap.set("n", "<leader>rm", "<cmd>CodeDiff main<cr>", { desc = "Code diff main" })
vim.keymap.set("n", "<leader>rh", "<cmd>CodeDiff HEAD~1<cr>", { desc = "Code diff previous commit" })
