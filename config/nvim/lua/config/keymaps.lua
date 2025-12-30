-- Keymap helper
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map('n', '<Esc>', '<cmd>nohlsearch<CR>')
map('n', "'", ':', opts)
map('i', 'jk', '<ESC>', opts)
map('n', '<leader><leader>', '<cmd>wa<cr>', { desc = 'Save all' })

-- General keymaps
map('n', '<C-left>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-right>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-down>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-up>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
map('n', '<C-\\>', '<C-w><C-w>', { desc = 'Circle focus to the all window' })
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

map('n', 'dw', 'vb_d') -- delete a word backup
map('n', '<C-a>', 'gg<S-v>G') -- select all

-- Move a line up or down in normal mode
map('n', '<A-down>', ':m .+1<CR>==', { desc = 'Move line down', noremap = true, silent = true })
map('n', '<A-up>', ':m .-2<CR>==', { desc = 'Move line up', noremap = true, silent = true })
-- map('n', '<A-K>', ':m .+1<CR>==', { desc = 'Move line down', noremap = true, silent = true })
-- map('n', '<A-J>', ':m .-2<CR>==', { desc = 'Move line up', noremap = true, silent = true })

-- Move a line or block up or down in visual mode
map('v', '<A-down>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down', noremap = true, silent = true })
map('v', '<A-up>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up', noremap = true, silent = true })

-- Resize window
map('n', '=', [[<cmd>vertical resize +5<cr>]])
map('n', '-', [[<cmd>vertical resize -5<cr>]])
map('n', '+', [[<cmd>horizontal resize +2<cr>]])
map('n', '_', [[<cmd>horizontal resize -2<cr>]])

-- split window
map('n', 'ss', ':split<CR>', opts) -- up/down
map('n', 'sv', ':vsplit<CR>', opts) -- left/right

map('n', '<leader>qa', ':qa<CR>', { desc = '[Q]uit [A]ll' }) -- close
map('n', '<leader>qc', ':close<CR>', { desc = 'Close' }) -- close
map('n', '<leader>qq', ':bp|bd#<CR>', { desc = 'Close but keep split window' }) -- close buffer

-- Diagnostic
map('n', '<leader>ee', vim.diagnostic.open_float, { desc = 'Open Errors' })
map('n', '<leader>en', vim.diagnostic.goto_next, { desc = '[N]ext Error' })
map('n', '<leader>ep', vim.diagnostic.goto_prev, { desc = '[P]revious Error' })
map('n', '<leader>eq', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Neo-tree
map('n', '\\', '<Cmd>Neotree position=float reveal<CR>')

-- Quickfix
map('n', 's', '', opts)
map('n', '<C-n>', ':cnext<CR>', { desc = 'Next search list' })
map('n', '<C-p>', ':cprevious<CR>', { desc = 'Previous search list' })
map('n', 'sc', ':cclose<CR>', { desc = '[C]lose search list' })
map('n', 'so', ':copen<CR>', { desc = '[O]pen search list' })

-- golang tags
-- map('n', '<leader>tajj', '<Cmd>GoAddTags json<CR>', { desc = 'Add tag json' })
-- map('n', '<leader>tajo', '<Cmd>GoAddTags json,omitempty<CR>', { desc = 'Add tag json with omitempty' })
-- map('n', '<leader>tayj', '<Cmd>GoAddTags yaml,omitempty<CR>', { desc = 'Add tag yaml' })
-- map('n', '<leader>tayo', '<Cmd>GoAddTags yaml,omitempty<CR>', { desc = 'Add tag yaml with omitempty' })
-- map('n', '<leader>trj', '<Cmd>GoRemoveTags json<CR>', { desc = 'Remove tag json' })
-- map('n', '<leader>try', '<Cmd>GoRemoveTags yaml<CR>', { desc = 'Remove tag yaml' })
