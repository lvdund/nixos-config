-- indent
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.list = true
vim.opt.listchars = { tab = '│ ', leadmultispace = '│ ', nbsp = '␣' }

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'json', 'jsonc', 'nix', 'yaml', 'dockerfile', 'yaml.docker-compose' },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end,
})
