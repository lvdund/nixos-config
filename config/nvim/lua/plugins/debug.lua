return {
  specs = {
    { src = 'https://github.com/nvim-neotest/neotest' },
    { src = 'https://github.com/nvim-neotest/nvim-nio' },
    { src = 'https://github.com/nvim-lua/plenary.nvim' },
    { src = 'https://github.com/antoinemadec/FixCursorHold.nvim' },
    { src = 'https://github.com/fredrikaverpil/neotest-golang' },
  },
  setup = function()
    require('neotest').setup({
      adapters = {
        require('neotest-golang')(function()
          local neotest_golang_opts = {}
          require('neotest').setup({
            adapters = {
              require('neotest-golang')(neotest_golang_opts),
            },
          })
        end),
      },
      diagnostic = {
        enabled = true,
      },
      floating = {
        border = 'rounded',
        max_height = 0.6,
        max_width = 0.6,
      },
      highlights = {
        adapter_name = 'NeotestAdapterName',
        border = 'NeotestBorder',
        dir = 'NeotestDir',
        expand_marker = 'NeotestExpandMarker',
        failed = 'NeotestFailed',
        file = 'NeotestFile',
        focused = 'NeotestFocused',
        indent = 'NeotestIndent',
        namespace = 'NeotestNamespace',
        passed = 'NeotestPassed',
        running = 'NeotestRunning',
        skipped = 'NeotestSkipped',
        test = 'NeotestTest',
      },
      output = {
        enabled = true,
        open_on_run = true,
      },
      output_panel = {
        enabled = true,
        open = 'botright vsplit | vertical resize 80',
      },
      run = {
        enabled = true,
      },
      status = {
        enabled = true,
      },
      strategies = {
        integrated = {
          height = 40,
          width = 120,
        },
      },
      summary = {
        enabled = true,
        expand_errors = true,
        follow = true,
      },
    })
  end,
  load_on = function(load)
    local function with_load(fn)
      return function()
        load()
        fn()
      end
    end

    vim.keymap.set('n', '<leader>do', with_load(function()
      require('neotest').output_panel.toggle()
    end), { desc = 'Output Panel' })

    vim.keymap.set('n', '<leader>dp', with_load(function()
      require('neotest').run.stop()
    end), { desc = 'Stop test' })

    vim.keymap.set('n', '<leader>ds', with_load(function()
      require('neotest').summary.toggle()
    end), { desc = 'Toggle Summary' })

    vim.keymap.set('n', '<leader>dt', with_load(function()
      require('neotest').run.run()
    end), { desc = 'Run test' })
  end,
}
