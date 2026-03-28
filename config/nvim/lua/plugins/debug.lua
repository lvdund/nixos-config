return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'fredrikaverpil/neotest-golang',
  },
  keys = {
    {
      '<leader>do',
      function()
        require('neotest').output_panel.toggle()
      end,
      desc = 'Output Panel',
    },
    { '<leader>dp', "<cmd>lua require('neotest').run.stop()<cr>", desc = 'Stop test' },
    { '<leader>ds', "<cmd>lua require('neotest').summary.toggle()<cr>", desc = 'Toggle Summary' },
    { '<leader>dt', "<cmd>lua require('neotest').run.run()<cr>", desc = 'Run test' },
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-golang'(function()
          local neotest_golang_opts = {} -- Specify custom configuration
          require('neotest').setup {
            adapters = {
              require 'neotest-golang'(neotest_golang_opts), -- Registration
            },
          }
        end), -- Apply configuration
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
    }
  end,
}
