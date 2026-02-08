-- Auto-load all Lua modules from a directory
local function load_modules(dir, prefix)
  local path = vim.fn.stdpath 'config' .. '/lua/' .. dir .. '/'
  for _, file in ipairs(vim.fn.readdir(path)) do
    if file:match '%.lua$' then
      require(prefix .. '.' .. file:gsub('%.lua$', ''))
    end
  end
end

load_modules('config', 'config')
load_modules('vd', 'vd')
require 'lsp'

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require('lazy').setup({
  { import = 'plugins' },
}, {
  change_detection = {
    enabled = false,
    notify = false,
  },
})
