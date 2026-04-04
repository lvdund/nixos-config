return {
  specs = {
    { src = 'https://github.com/folke/which-key.nvim' },
  },
  setup = function()
    require('which-key').setup {
      preset = 'helix',
      delay = 0,
      icons = { mappings = true },
      spec = {
        { 's', group = '  [S]urround' },
        { '<leader>b', group = '[B]uffer' },
        { '<leader>d', group = '[D]ebug' },
        { '<leader>e', group = '[E]rror' },
        { '<leader>g', group = '[G]it' },
        { '<leader>q', group = '[Q]uit' },
        { '<leader>o', group = '[O]penCode' },
        { '<leader>s', group = '[S]earch' },
      },
    }
  end,
}
