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
          add = 'sra',
          delete = 'srd',
          replace = 'srr',
          find = 'srf',
          find_left = 'srF',
          highlight = 'srh',
          suffix_last = 'l',
          suffix_next = 'n',
        },
      }
    end,
  },
}
