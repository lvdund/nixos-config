local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("n", "'", ":", opts)
map("i", "jk", "<ESC>", opts)

map("n", "<leader>cp", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy absolute path" })

map("n", "<leader>cr", function()
  local path = vim.fn.expand("%")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy relative path" })

map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
map("n", "<C-left>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-right>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-down>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-up>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
map("n", "<C-\\>", "<C-w><C-w>", { desc = "Circle focus to all windows" })

map("n", "dw", "vb_d")
map("n", "<C-a>", "gg<S-v>G")
map("x", "p", [["_dP]])

map("n", "<A-down>", ":m .+1<CR>==", { desc = "Move line down", noremap = true, silent = true })
map("n", "<A-up>", ":m .-2<CR>==", { desc = "Move line up", noremap = true, silent = true })
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down", noremap = true, silent = true })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up", noremap = true, silent = true })
map("v", "<A-down>", ":m '>+1<CR>gv=gv", { desc = "Move selection down", noremap = true, silent = true })
map("v", "<A-up>", ":m '<-2<CR>gv=gv", { desc = "Move selection up", noremap = true, silent = true })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down", noremap = true, silent = true })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up", noremap = true, silent = true })

map("n", "=", [[<cmd>vertical resize +5<cr>]])
map("n", "-", [[<cmd>vertical resize -5<cr>]])
map("n", "+", [[<cmd>horizontal resize +2<cr>]])
map("n", "_", [[<cmd>horizontal resize -2<cr>]])

map("n", "<leader>ee", vim.diagnostic.open_float, { desc = "Open errors" })
map("n", "<leader>eq", vim.diagnostic.setloclist, { desc = "Open diagnostic quickfix list" })

map("n", "s", "", opts)
map("n", "<C-n>", ":cnext<CR>", { desc = "Next search list" })
map("n", "<C-p>", ":cprevious<CR>", { desc = "Previous search list" })
map("n", "sc", ":cclose<CR>", { desc = "[C]lose search list" })
map("n", "so", ":copen<CR>", { desc = "[O]pen search list" })
