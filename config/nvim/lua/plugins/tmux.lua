return {
  specs = {
    { src = 'https://github.com/christoomey/vim-tmux-navigator' },
  },
  setup = function() end,
  load_on = function(load)
    local keys = {
      { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
      { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>' },
      { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>' },
      { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>' },
      { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
    }

    for _, key_def in ipairs(keys) do
      vim.keymap.set('n', key_def[1], function()
        load()
        vim.keymap.set('n', key_def[1], key_def[2], { noremap = true })
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key_def[1], true, false, true), 'n', false)
      end, { desc = 'Tmux navigate' })
    end
  end,
}
