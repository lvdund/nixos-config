return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    -- Optional dependencies
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    config = function()
      vim.keymap.set('n', '\\', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
      require('oil').setup {
        default_file_explorer = true,
        columns = {
          'icon',
          -- "permissions",
          -- "size",
          -- "mtime",
        },
        -- Buffer-local options to use for oil buffers
        buf_options = {
          buflisted = false,
          bufhidden = 'hide',
        },
        -- Window-local options to use for oil buffers
        win_options = {
          wrap = false,
          signcolumn = 'no',
          cursorcolumn = false,
          foldcolumn = '0',
          spell = false,
          list = false,
          conceallevel = 3,
          concealcursor = 'nvic',
        },
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
        -- (:help prompt_save_on_select_new_entry)
        prompt_save_on_select_new_entry = true,
        cleanup_delay_ms = 2000,
        lsp_file_methods = {
          enabled = true,
          timeout_ms = 1000,
          autosave_changes = true,
        },
        constrain_cursor = 'editable',
        watch_for_changes = false,
        keymaps = {
          ['g?'] = { 'actions.show_help', mode = 'n' },
          ['<CR>'] = 'actions.select',
          ['<C-v>'] = { 'actions.select', opts = { vertical = true } },
          ['<C-h>'] = { 'actions.select', opts = { horizontal = true } },
          ['<C-t>'] = { 'actions.select', opts = { tab = true } },
          ['<C-p>'] = 'actions.preview',
          ['<C-c>'] = { 'actions.close', mode = 'n' },
          ['<C-l>'] = 'actions.refresh',
          ['-'] = { 'actions.parent', mode = 'n' },
          ['_'] = { 'actions.open_cwd', mode = 'n' },
          ['`'] = { 'actions.cd', mode = 'n' },
          ['g~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
          ['gs'] = { 'actions.change_sort', mode = 'n' },
          ['gx'] = 'actions.open_external',
          ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
          ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
        },
        use_default_keymaps = false,
        view_options = {
          show_hidden = true,
          is_hidden_file = function(name, bufnr)
            local m = name:match '^%.'
            return m ~= nil
          end,
          is_always_hidden = function(name, bufnr)
            return false
          end,
          natural_order = 'fast',
          case_insensitive = true,
          sort = {
            { 'type', 'asc' },
            { 'name', 'asc' },
          },
          highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
            return nil
          end,
        },
        extra_scp_args = {},
        extra_s3_args = {},
        git = {
          add = function(path)
            return false
          end,
          mv = function(src_path, dest_path)
            return false
          end,
          rm = function(path)
            return false
          end,
        },
        float = {
          padding = 2,
          max_width = 0,
          max_height = 0,
          border = nil,
          win_options = { winblend = 0 },
          get_win_title = nil,
          preview_split = 'auto',
          override = function(conf)
            return conf
          end,
        },
        preview_win = {
          update_on_cursor_moved = true,
          preview_method = 'fast_scratch',
          disable_preview = function(filename)
            return false
          end,
          win_options = {},
        },
        confirmation = {
          max_width = 0.9,
          min_width = { 40, 0.4 },
          width = nil,
          max_height = 0.9,
          min_height = { 5, 0.1 },
          height = nil,
          border = nil,
          win_options = { winblend = 0 },
        },
        progress = {
          max_width = 0.9,
          min_width = { 40, 0.4 },
          width = nil,
          max_height = { 10, 0.9 },
          min_height = { 5, 0.1 },
          height = nil,
          border = nil,
          minimized_border = 'none',
          win_options = { winblend = 0 },
        },
        ssh = { border = nil },
        keymaps_help = { border = nil },
      }
    end,
  },
  {
    'malewicz1337/oil-git.nvim',
    dependencies = { 'stevearc/oil.nvim' },
    config = function()
      require('oil-git').setup {
        debounce_ms = 50,
        show_file_highlights = true,
        show_directory_highlights = true,
        show_file_symbols = true,
        show_directory_symbols = true,
        show_ignored_files = true, -- Show ignored file status
        show_ignored_directories = true, -- Show ignored directory status
        symbol_position = 'eol', -- "eol", "signcolumn", or "none"
        can_use_signcolumn = nil, -- Optional callback(bufnr): nil|bool|string
        ignore_gitsigns_update = false, -- Ignore GitSignsUpdate events (fallback for flickering)
        debug = false, -- false, "minimal", or "verbose"
        symbols = {
          file = { added = '+', modified = '~', renamed = '->', deleted = 'D', copied = 'C', conflict = '!', untracked = '?', ignored = 'o' },
          directory = {
            added = '*',
            modified = '*',
            renamed = '*',
            deleted = '*',
            copied = '*',
            conflict = '!',
            untracked = '*',
            ignored = 'o',
          },
        },
        -- Colors (only applied if highlight groups don't exist)
        highlights = {
          OilGitAdded = { fg = '#a6e3a1' },
          OilGitModifiedStaged = { fg = '#f9e2af' },
          OilGitModifiedUnstaged = { fg = '#e5c890' },
          OilGitRenamed = { fg = '#cba6f7' },
          OilGitDeleted = { fg = '#f38ba8' },
          OilGitCopied = { fg = '#cba6f7' },
          OilGitConflict = { fg = '#fab387' },
          OilGitUntracked = { fg = '#89b4fa' },
          OilGitIgnored = { fg = '#6c7086' },
        },
      }
    end,
  },
}
