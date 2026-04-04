return {
  specs = {
    { src = 'https://github.com/Saecki/crates.nvim' },
    { src = 'https://github.com/selimacerbas/markdown-preview.nvim' },
    { src = 'https://github.com/selimacerbas/live-server.nvim' },
    { src = 'https://github.com/zgs225/gomodifytags.nvim' },
  },
  setup = function()
    require('crates').setup({
      completion = {
        crates = {
          enabled = true,
        },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    })

    require('markdown_preview').setup({
      port = 8421,
      open_browser = true,
      debounce_ms = 300,
    })

    vim.keymap.set('n', '<leader>mm', '<cmd>MarkdownPreview<cr>', { desc = 'Markdown: Start preview' })
    vim.keymap.set('n', '<leader>ms', '<cmd>MarkdownPreviewStop<cr>', { desc = 'Markdown: Stop preview' })
    vim.keymap.set('n', '<leader>mr', '<cmd>MarkdownPreviewRefresh<cr>', { desc = 'Markdown: Refresh preview' })

    require('gomodifytags').setup()
  end,
  load_on = function(load)
    vim.api.nvim_create_autocmd('BufRead', {
      pattern = 'Cargo.toml',
      once = true,
      callback = function()
        load()
      end,
    })

    for _, cmd_name in ipairs({ 'MarkdownPreview', 'MarkdownPreviewStop', 'MarkdownPreviewRefresh' }) do
      vim.api.nvim_create_user_command(cmd_name, function(opts)
        load()
        vim.cmd(cmd_name .. (opts.args ~= '' and (' ' .. opts.args) or ''))
      end, { nargs = '*' })
    end

    for _, cmd_name in ipairs({ 'GoAddTags', 'GoRemoveTags', 'GoInstallModifyTagsBin' }) do
      vim.api.nvim_create_user_command(cmd_name, function(opts)
        load()
        vim.cmd(cmd_name .. (opts.args ~= '' and (' ' .. opts.args) or ''))
      end, { nargs = '*' })
    end
  end,
}
