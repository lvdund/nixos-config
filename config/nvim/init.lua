vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local function load_modules(dir, prefix)
  local path = vim.fn.stdpath('config') .. '/lua/' .. dir .. '/'
  for _, file in ipairs(vim.fn.readdir(path)) do
    if file:match('%.lua$') then
      require(prefix .. '.' .. file:gsub('%.lua$', ''))
    end
  end
end

load_modules('config', 'config')
load_modules('vd', 'vd')
require('plugins')
require('lsp')

vim.cmd.packadd('cfilter')
vim.cmd.packadd('nvim.difftool')
vim.cmd.packadd('nvim.undotree')


vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

