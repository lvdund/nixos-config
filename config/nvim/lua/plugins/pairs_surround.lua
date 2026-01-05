return {
  {
    'nvim-mini/mini.pairs',
    version = '*',
    config = function()
      require('mini.pairs').setup()
    end,
  },
  {
    'nvim-mini/mini.surround',
    version = '*',
    config = function()
      require('mini.surround').setup {
        mappings = {
          add = 'sa',
          delete = 'sd',
          find = 'sf',
          find_left = 'sF',
          highlight = 'sh',
          replace = 'sr',
          suffix_last = 'l',
          suffix_next = 'n',
        },
      }
    end,
  },
  {
    'mg979/vim-visual-multi',
    branch = 'master',
    init = function()
      vim.g.VM_theme = 'iceblue'
      vim.g.VM_highlight_matches = 'underline'
      vim.g.VM_default_mappings = 0
      vim.g.VM_maps = {
        ['Find Under'] = '<C-d>', -- Ctrl+D select next
        ['Find Subword Under'] = '<C-d>',
        ['Select All'] = '<M-a>',
        ['Skip Region'] = '<C-x>',
        ['Remove Region'] = 'q',
      }
    end,
  },
}
