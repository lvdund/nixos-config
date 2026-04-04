return {
  specs = {
    { src = 'https://github.com/echasnovski/mini.pairs', name = 'mini.pairs' },
    { src = 'https://github.com/echasnovski/mini.surround', name = 'mini.surround' },
  },
  setup = function()
    require('mini.pairs').setup()
    require('mini.surround').setup({
      mappings = {
        add = 'sra', delete = 'srd', replace = 'srr', find = 'srf',
        find_left = 'srF', highlight = 'srh', suffix_last = 'l', suffix_next = 'n',
      },
    })
  end,
}
