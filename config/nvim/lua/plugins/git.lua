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
      signcolumn = true,
      numhl = false,
      linehl = false,
      word_diff = false,
      watch_gitdir = {
        follow_files = true,
      },
      auto_attach = true,
      attach_to_untracked = false,
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 100,
        ignore_whitespace = false,
        virt_text_priority = 100,
        use_focus = true,
      },
      current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil,
      max_file_length = 40000,
      preview_config = {
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1,
      },
      on_attach = function(bufnr)
        if vim.bo[bufnr].filetype == 'neo-tree' then
          return
        end

        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'next change' })
        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'prev change' })

        map('n', '<leader>grb', gitsigns.reset_buffer, { desc = '[G]it [R]eset [B]uffer' })
        map('n', '<leader>grh', gitsigns.reset_hunk, { desc = '[G]it [R]eset [H]unk' })
        map('n', 'gp', gitsigns.preview_hunk, { desc = '[G]it [P]review change' })
        map('n', '<leader>gt', ':Gitsigns toggle_current_line_blame<CR>', { desc = '[G]it [T]oggle Line Blame' })
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
          line_insert = 'DiffAdd',
          line_delete = 'DiffDelete',
          char_insert = nil,
          char_delete = nil,
          char_brightness = nil,
        },
        diff = {
          disable_inlay_hints = true,
          max_computation_time_ms = 5000,
        },
        explorer = {
          position = 'left',
          width = 40,
          height = 15,
          indent_markers = true,
          icons = {
            folder_closed = ' ',
            folder_open = ' ',
          },
          view_mode = 'list',
          file_filter = {
            ignore = { '*.lock', 'dist/*' },
          },
        },
        keymaps = {
          view = {
            quit = 'q',
            toggle_explorer = '<leader>bb',
            next_hunk = ']c',
            prev_hunk = '[c',
            next_file = ']f',
            prev_file = '[f',
            diff_get = 'do',
            diff_put = 'dp',
          },
          explorer = {
            select = '<CR>',
            hover = 'K',
            refresh = 'R',
            toggle_view_mode = 'i',
          },
        },
      }
    end,
  },
}
