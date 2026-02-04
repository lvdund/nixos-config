-- Keymap helper
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map('n', '<Esc>', '<cmd>nohlsearch<CR>')
map('n', "'", ':', opts)
map('i', 'jk', '<ESC>', opts)
-- map('n', '<leader><leader>', '<cmd>wa<cr>', { desc = 'Save all' })

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
map('x', 'p', [["_dP]]) -- Paste without overwriting register

-- Move a line up or down in normal mode
map('n', '<A-down>', ':m .+1<CR>==', { desc = 'Move line down', noremap = true, silent = true })
map('n', '<A-up>', ':m .-2<CR>==', { desc = 'Move line up', noremap = true, silent = true })
map('n', '<A-j>', ':m .+1<CR>==', { desc = 'Move line down', noremap = true, silent = true })
map('n', '<A-k>', ':m .-2<CR>==', { desc = 'Move line up', noremap = true, silent = true })
map('v', '<A-down>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down', noremap = true, silent = true })
map('v', '<A-up>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up', noremap = true, silent = true })
map('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down', noremap = true, silent = true })
map('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up', noremap = true, silent = true })

-- Resize window
map('n', '=', [[<cmd>vertical resize +5<cr>]])
map('n', '-', [[<cmd>vertical resize -5<cr>]])
map('n', '+', [[<cmd>horizontal resize +2<cr>]])
map('n', '_', [[<cmd>horizontal resize -2<cr>]])

-- split window & buffer
map('n', 'ss', ':split<CR>', opts) -- up/down
map('n', 'sv', ':vsplit<CR>', opts) -- left/right

local function get_unsaved_buffers()
  local buffers = vim.fn.getbufinfo { buflisted = 1 }
  local unsaved = {}
  for _, buf in ipairs(buffers) do
    if buf.changed == 1 then
      table.insert(unsaved, buf.name ~= '' and buf.name or '[No Name]')
    end
  end
  return unsaved
end

local function check_unsaved_buffers(action_name)
  local unsaved = get_unsaved_buffers()
  if #unsaved > 0 then
    local msg = action_name .. ' cancelled. Unsaved buffers:\n'
    for _, name in ipairs(unsaved) do
      msg = msg .. '  - ' .. name .. '\n'
    end
    vim.notify(msg, vim.log.levels.WARN)
    return true
  end
  return false
end

local function save_all()
  local unsaved = get_unsaved_buffers()
  if #unsaved == 0 then
    vim.notify('No unsaved buffers to save', vim.log.levels.INFO)
    return
  end
  vim.cmd 'wa'
  local msg = 'Saved ' .. #unsaved .. ' buffer(s):\n'
  for _, name in ipairs(unsaved) do
    msg = msg .. '  - ' .. name .. '\n'
  end
  vim.notify(msg, vim.log.levels.INFO)
end

local function close_all_other_buffers()
  if check_unsaved_buffers 'Close all other buffers' then
    return
  end
  vim.cmd '%bd|e#|bd#'
end

local function close_buffer_keep_split()
  if check_unsaved_buffers 'Close buffer' then
    return
  end
  vim.cmd 'bp|bd#'
end

local function close_all_buffers()
  if check_unsaved_buffers 'Close all buffers' then
    return
  end
  vim.cmd '%bd'
end

local function quit_all()
  if check_unsaved_buffers 'Quit all' then
    return
  end
  vim.cmd 'qa'
end

map('n', '<leader>tt', ':tabclose<CR>', { desc = 'close tab' }) -- close
map('n', '<leader>qa', quit_all, { desc = '[Q]uit [A]ll' })
map('n', '<leader>qc', ':wa|close<CR>', { desc = 'Close Window' }) -- close
map('n', '<leader><leader>', save_all, { desc = 'Save all' })
map('n', '<leader>bo', close_all_other_buffers, { desc = 'Close all other buffers' })
map('n', '<leader>bc', close_buffer_keep_split, { desc = 'Close but keep split window' })
map('n', '<leader>ba', close_all_buffers, { desc = 'Close all buffers' })
map('n', '<leader>bA', ':wa|bw!<CR>', { desc = 'Close all buffer (Force)' })

-- Diagnostic
map('n', '<leader>ee', vim.diagnostic.open_float, { desc = 'Open Errors' })
-- map('n', '<leader>en', vim.diagnostic.goto_next, { desc = '[N]ext Error' })
-- map('n', '<leader>ep', vim.diagnostic.goto_prev, { desc = '[P]revious Error' })
-- map('n', '<leader>eq', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

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
