vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })

require('mini.tabline').setup(
  {
    -- Whether to show file icons (requires 'mini.icons')
    show_icons = true,
    format = nil,
    tabpage_section = 'left',
  })
