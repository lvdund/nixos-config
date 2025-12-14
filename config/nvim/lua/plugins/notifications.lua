return {
  {
    'rcarriga/nvim-notify',
    opts = {
      render = 'compact',
      stages = 'slide',
      timeout = 1000,
    },
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      presets = {
        bottom_search = true,
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
      cmdline = {
        enabled = true,
        view = 'cmdline',
        format = {
          cmdline = { icon = ' ' },
          search_down = { icon = ' ' },
          search_up = { icon = ' ' },
          filter = { icon = '$' },
          lua = { icon = '󰢱 ' },
          help = { icon = '󰋖' },
        },
      },
    },
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
  },
}
