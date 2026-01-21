-- highlight
local function setup_todo_highlight()
  vim.api.nvim_set_hl(0, 'TodoWARN', { fg = '#000000', bg = '#FFCC00', bold = true })
  vim.api.nvim_set_hl(0, 'TodoFix', { fg = '#ffffff', bg = '#FF0000', bold = true })
  vim.api.nvim_set_hl(0, 'TodoNote', { fg = '#000000', bg = '#00FFAB', bold = true })
  vim.cmd [[
      syntax match TodoWARN "\v<(WARN|REMIND):"
      syntax match TodoFix  "\v<(FIXME|ERROR|BUG|FIX):"
      syntax match TodoNote "\v<(TODO|NOTE|INFO|OPTIMIZE):"
    ]]
end
vim.api.nvim_create_autocmd({ 'FileType', 'BufWinEnter' }, {
  callback = setup_todo_highlight,
})

-- highlight find with fzf
vim.keymap.set('n', '<leader>st', function()
  require('fzf-lua').grep {
    search = [[\b(WARN|REMIND|FIXME|ERROR|BUG|FIX|TODO|NOTE|INFO|OPTIMIZE):]],
    no_esc = true,
    prompt = 'TODO ❯ ',
  }
end, { desc = '[S]earch TODO tags' })
