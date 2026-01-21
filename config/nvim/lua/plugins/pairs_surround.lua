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
          replace = 'sr',
        },
      }
    end,
  },
}
