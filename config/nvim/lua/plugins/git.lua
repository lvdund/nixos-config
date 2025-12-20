return {
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '┃' },
        change = { text = '┃' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      signs_staged = {
        add = { text = '┃' },
        change = { text = '┃' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      signs_staged_enable = true,
      signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
      numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = {
        follow_files = true,
      },
      auto_attach = true,
      attach_to_untracked = false,
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 100,
        ignore_whitespace = false,
        virt_text_priority = 100,
        use_focus = true,
      },
      current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil, -- Use default
      max_file_length = 40000, -- Disable if file is longer than this (in lines)
      preview_config = {
        -- Options passed to nvim_open_win
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1,
      },

      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end)
        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end)

        -- Actions
        map('n', '<leader>gR', gitsigns.reset_buffer, { desc = '[G]it [R]eset buffer' })
        map('n', '<leader>gp', gitsigns.preview_hunk, { desc = '[G]it [P]review change' })
        map('n', '<leader>gs', ":TermExec cmd='git status'<CR>", { desc = '[G]it [S]tatus' })
        map('n', '<leader>gtb', ':Gitsigns toggle_current_line_blame<CR>', { desc = '[G]it [T]oggle [B]lame' })

        -- Navigate
        map('n', ']g', ':Gitsigns nav_hunk next<CR>', { desc = 'Git next hunk' })
        map('n', '[g', ':Gitsigns nav_hunk prev<CR>', { desc = 'Git prev hunk' })
      end,
    },
  },
  {
    'esmuellert/vscode-diff.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    cmd = 'CodeDiff',
    config = function()
      require('vscode-diff').setup {
        highlights = {
          line_insert = 'DiffAdd', -- Line-level insertions
          line_delete = 'DiffDelete', -- Line-level deletions
          char_insert = nil, -- Character-level insertions (nil = auto-derive)
          char_delete = nil, -- Character-level deletions (nil = auto-derive)
          char_brightness = nil, -- Auto-adjust based on your colorscheme
        },
        diff = {
          disable_inlay_hints = true, -- Disable inlay hints in diff windows for cleaner view
          max_computation_time_ms = 5000, -- Maximum time for diff computation (VSCode default)
        },
        explorer = {
          position = 'left', -- "left" or "bottom"
          width = 40, -- Width when position is "left" (columns)
          height = 15, -- Height when position is "bottom" (lines)
          indent_markers = true, -- Show indent markers in tree view (│, ├, └)
          icons = {
            folder_closed = ' ', -- Nerd Font folder icon (customize as needed)
            folder_open = ' ', -- Nerd Font folder-open icon
          },
          view_mode = 'list', -- "list" or "tree"
          file_filter = {
            ignore = { '*.lock', 'dist/*' },
          },
        },

        -- Keymaps in diff view
        keymaps = {
          view = {
            quit = 'q', -- Close diff tab
            toggle_explorer = '<leader>bb', -- Toggle explorer visibility (explorer mode only)
            next_hunk = ']c', -- Jump to next change
            prev_hunk = '[c', -- Jump to previous change
            next_file = ']f', -- Next file in explorer mode
            prev_file = '[f', -- Previous file in explorer mode
            diff_get = 'do', -- Get change from other buffer (like vimdiff)
            diff_put = 'dp', -- Put change to other buffer (like vimdiff)
          },
          explorer = {
            select = '<CR>', -- Open diff for selected file
            hover = 'K', -- Show file diff preview
            refresh = 'R', -- Refresh git status
            toggle_view_mode = 'i', -- Toggle between 'list' and 'tree' views
          },
        },
      }
    end,
  },
}
