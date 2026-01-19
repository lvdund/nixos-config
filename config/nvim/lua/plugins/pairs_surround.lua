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
}
