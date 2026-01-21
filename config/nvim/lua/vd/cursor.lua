-- highlight same under cursor
vim.api.nvim_set_hl(0, 'WordUnderline', { underline = true })
local group = vim.api.nvim_create_augroup('CursorLineWord', { clear = true })
vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
  group = group,
  callback = function()
    local word = vim.fn.expand '<cword>'
    if word ~= '' then
      vim.fn.matchadd('WordUnderline', [[\<]] .. word .. [[\>]], -1)
    end
  end,
})
vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
  group = group,
  callback = function()
    vim.fn.clearmatches()
  end,
})
