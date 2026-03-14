return {
  {
    'Saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    opts = {
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
    },
  },
  {
    'selimacerbas/markdown-preview.nvim',
    dependencies = { 'selimacerbas/live-server.nvim' },
    config = function()
      require('markdown_preview').setup {
        -- all optional; sane defaults shown
        port = 8421,
        open_browser = true,
        debounce_ms = 300,
      }
      vim.keymap.set('n', '<leader>mm', '<cmd>MarkdownPreview<cr>', { desc = 'Markdown: Start preview' })
      vim.keymap.set('n', '<leader>ms', '<cmd>MarkdownPreviewStop<cr>', { desc = 'Markdown: Stop preview' })
      vim.keymap.set('n', '<leader>mr', '<cmd>MarkdownPreviewRefresh<cr>', { desc = 'Markdown: Refresh preview' })
    end,
  },
  {
    'zgs225/gomodifytags.nvim',
    cmd = { 'GoAddTags', 'GoRemoveTags', 'GoInstallModifyTagsBin' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('gomodifytags').setup()
    end,
  },
}
