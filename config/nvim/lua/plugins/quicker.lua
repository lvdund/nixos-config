return {
  'stevearc/quicker.nvim',
  ft = 'qf',
  ---@module "quicker"
  ---@type quicker.SetupOptions
  config = function()
    vim.keymap.set('n', '<leader>qq', function()
      require('quicker').toggle()
    end, { desc = 'Toggle [Q]uickfix' })
    vim.keymap.set('n', '<leader>ql', function()
      require('quicker').toggle { loclist = true }
    end, { desc = 'Toggle [L]oclist' })
    require('quicker').setup {
      keys = {
        {
          '>',
          function()
            require('quicker').expand { before = 2, after = 2, add_to_existing = true }
          end,
          desc = 'Expand quickfix context',
        },
        {
          '<',
          function()
            require('quicker').collapse()
          end,
          desc = 'Collapse quickfix context',
        },
      },
    }
  end,
}
