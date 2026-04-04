local icons = { Error = '', Warn = '', Hint = '󰌶', Info = '' }

return {
  specs = {
    { src = 'https://github.com/akinsho/bufferline.nvim' },
  },
  setup = function()
    local function close_empty_unnamed_buffers()
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_get_name(bufnr) == '' and vim.bo[bufnr].buftype == '' then
          local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
          local total_chars = 0
          for _, line in ipairs(lines) do total_chars = total_chars + #line end
          if total_chars == 0 then vim.api.nvim_buf_delete(bufnr, { force = true }) end
        end
      end
    end

    require('bufferline').setup({
      highlights = { buffer_selected = { bold = true, italic = true } },
      options = {
        diagnostics = 'nvim_lsp',
        diagnostics_indicator = function(_, _, diag)
          local ret = (diag.error and icons.Error .. diag.error .. ' ' or '')
            .. (diag.warning and icons.Warn .. diag.warning or '')
          return vim.trim(ret)
        end,
        hover = { enabled = true, delay = 200, reveal = { 'close' } },
        indicator = { icon = '▎', style = 'underline' },
      },
    })
    vim.api.nvim_create_autocmd('BufReadPost', { callback = close_empty_unnamed_buffers })
    vim.keymap.set('n', '<leader>ba', '<Cmd>bufdo bd<CR>', { desc = 'Close all Buffer' })
    vim.keymap.set('n', '[B', '<Cmd>BufferLineMovePrev<CR>', { desc = 'Move Buffers Left' })
    vim.keymap.set('n', ']B', '<Cmd>BufferLineMoveNext<CR>', { desc = 'Move Buffers Right' })
    vim.keymap.set('n', '<leader>bo', '<Cmd>BufferLineCloseOthers<CR>', { desc = 'Close Other Buffer' })
  end,
}
