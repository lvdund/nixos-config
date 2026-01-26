return { -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  event = 'VimEnter', -- Sets the loading event to 'VimEnter'
  opts = {
    preset = 'helix',
    delay = 0,
    icons = {
      mappings = true,
    },

    -- Document existing key chains
    spec = {
      { 's', group = ' [S]urround' },
      { '<leader>b', group = '📄[B]uffer' },
      { '<leader>d', group = '🐞[D]ebug' },
      { '<leader>e', group = '❗[E]rror' },
      { '<leader>q', group = '🚪[Q]uit' },
      { '<leader>o', group = '🤖[O]penCode' },
      { '<leader>os', group = '󰋃 [O]penCode [S]ession' },
      { '<leader>op', group = ' [O]penCode [P]ermission' },
      { '<leader>or', group = '󰕌 [O]penCode [R]evert' },
      { '<leader>s', group = '🔎[S]earch' },
    },
  },
}
