local map = vim.keymap.set
local opts = { noremap = true, silent = true }

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

  local current_buf = vim.api.nvim_get_current_buf()
  local buffers = vim.fn.getbufinfo { buflisted = 1 }

  for _, buf in ipairs(buffers) do
    if buf.bufnr ~= current_buf then
      local buftype = vim.api.nvim_get_option_value('buftype', { buf = buf.bufnr })
      pcall(vim.api.nvim_buf_delete, buf.bufnr, { force = buftype == 'terminal' })
    end
  end
  vim.notify('Closed all other buffers', vim.log.levels.INFO)
end

local function close_buffer_keep_split()
  if check_unsaved_buffers 'Close buffer' then
    return
  end
  vim.cmd 'bp|bd#'
  vim.notify('Closed buffer', vim.log.levels.INFO)
end

local function close_all_buffers()
  if check_unsaved_buffers 'Close all buffers' then
    return
  end

  local buffers = vim.fn.getbufinfo { buflisted = 1 }
  for _, buf in ipairs(buffers) do
    local buftype = vim.api.nvim_get_option_value('buftype', { buf = buf.bufnr })
    pcall(vim.api.nvim_buf_delete, buf.bufnr, { force = buftype == 'terminal' })
  end
  vim.notify('Closed all buffers', vim.log.levels.INFO)
end

local function quit_all()
  if check_unsaved_buffers 'Quit all' then
    return
  end
  vim.cmd 'qa'
end

local function force_close_buffers()
  vim.cmd 'wa|bw!'
  vim.notify('Force closed buffer', vim.log.levels.INFO)
end

map('n', '<leader>tt', ':tabclose<CR>', { desc = 'close tab' }) -- close
map('n', '<leader>qa', quit_all, { desc = '[Q]uit [A]ll' })
map('n', '<leader>qq', ':wa|close<CR>', { desc = 'Close Window' }) -- close
map('n', 'qq', ':wa|close<CR>', { desc = 'Close Window' }) -- close
map('n', '<leader><leader>', save_all, { desc = 'Save all' })
map('n', '<leader>bo', close_all_other_buffers, { desc = 'Close all other buffers' })
map('n', '<leader>bc', close_buffer_keep_split, { desc = 'Close but keep split window' })
map('n', '<leader>ba', close_all_buffers, { desc = 'Close all buffers' })
map('n', '<leader>bA', force_close_buffers, { desc = 'Close all buffer (Force)' })

map({ 'n', 'v' }, '<Tab>', function()
  require('fzf-lua').buffers()
end, { desc = '[S]earch [B]uffers' })

-- split window & buffer
map('n', 'sh', ':split<CR>', opts) -- up/down
map('n', 'sv', ':vsplit<CR>', opts) -- left/right
