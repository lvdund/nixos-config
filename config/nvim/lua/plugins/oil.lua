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
          'permissions',
          'size',
          'mtime',
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
        skip_confirm_for_simple_edits = false,
        prompt_save_on_select_new_entry = true,
        cleanup_delay_ms = 2000,
        lsp_file_methods = {
          enabled = true,
          timeout_ms = 1000,
          -- Set to "unmodified" to only save unmodified buffers
          autosave_changes = false,
        },
        -- Constrain the cursor to the editable parts of the oil buffer
        -- Set to `false` to disable, or "name" to keep it on the file names
        constrain_cursor = 'editable',
        -- Set to true to watch the filesystem for changes and reload oil
        watch_for_changes = false,
        -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
        -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
        -- Additionally, if it is a string that matches "actions.<name>",
        -- it will use the mapping at require("oil.actions").<name>
        -- Set to `false` to remove a keymap
        -- See :help oil-actions for a list of all available actions
        keymaps = {
          ['g?'] = { 'actions.show_help', mode = 'n' },
          ['<CR>'] = 'actions.select',
          ['<C-v>'] = { 'actions.select', opts = { vertical = true } },
          ['<C-h>'] = { 'actions.select', opts = { horizontal = true } },
          ['<C-t>'] = { 'actions.select', opts = { tab = true } },
          ['<C-p>'] = 'actions.preview',
          ['<C-c>'] = { 'actions.close', mode = 'n' },
          ['q'] = { 'actions.close', mode = 'n' },
          ['<C-r>'] = 'actions.refresh',
          ['\\'] = { 'actions.parent', mode = 'n' },
          ['_'] = { 'actions.open_cwd', mode = 'n' },
          ['`'] = { 'actions.cd', mode = 'n' },
          ['g~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
          ['gs'] = { 'actions.change_sort', mode = 'n' },
          ['gx'] = 'actions.open_external',
          ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
          ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
        },
        -- Set to false to disable all of the above keymaps
        use_default_keymaps = false,
        view_options = {
          show_hidden = true,
          -- This function defines what is considered a "hidden" file
          is_hidden_file = function(name, bufnr)
            local m = name:match '^%.'
            return m ~= nil
          end,
          -- This function defines what will never be shown, even when `show_hidden` is set
          is_always_hidden = function(name, bufnr)
            return false
          end,
          -- Sort file names with numbers in a more intuitive order for humans.
          -- Can be "fast", true, or false. "fast" will turn it off for large directories.
          natural_order = 'fast',
          -- Sort file and directory names case insensitive
          case_insensitive = false,
          sort = {
            -- sort order can be "asc" or "desc"
            -- see :help oil-columns to see which columns are sortable
            { 'type', 'asc' },
            { 'name', 'asc' },
          },
          -- Customize the highlight group for the file name
          highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
            return nil
          end,
        },
        -- Extra arguments to pass to SCP when moving/copying files over SSH
        extra_scp_args = {},
        -- Extra arguments to pass to aws s3 when creating/deleting/moving/copying files using aws s3
        extra_s3_args = {},
        -- EXPERIMENTAL support for performing file operations with git
        git = {
          -- Return true to automatically git add/mv/rm files
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
        -- Configuration for the floating window in oil.open_float
        float = {
          -- Padding around the floating window
          padding = 2,
          -- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
          max_width = 0.8,
          max_height = 0.8,
          border = nil,
          win_options = {
            winblend = 0,
          },
          -- optionally override the oil buffers window title with custom function: fun(winid: integer): string
          get_win_title = nil,
          -- preview_split: Split direction: "auto", "left", "right", "above", "below".
          preview_split = 'auto',
          -- This is the config that will be passed to nvim_open_win.
          -- Change values here to customize the layout
          override = function(conf)
            return conf
          end,
        },
        -- Configuration for the file preview window
        preview_win = {
          -- Whether the preview window is automatically updated when the cursor is moved
          update_on_cursor_moved = true,
          -- How to open the preview window "load"|"scratch"|"fast_scratch"
          preview_method = 'fast_scratch',
          -- A function that returns true to disable preview on a file e.g. to avoid lag
          disable_preview = function(filename)
            return false
          end,
          -- Window-local options to use for preview window buffers
          win_options = {},
        },
        -- Configuration for the floating action confirmation window
        confirmation = {
          -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
          -- min_width and max_width can be a single value or a list of mixed integer/float types.
          -- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
          max_width = 0.9,
          -- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
          min_width = { 40, 0.4 },
          -- optionally define an integer/float for the exact width of the preview window
          width = nil,
          -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
          -- min_height and max_height can be a single value or a list of mixed integer/float types.
          -- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
          max_height = 0.9,
          -- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
          min_height = { 5, 0.1 },
          -- optionally define an integer/float for the exact height of the preview window
          height = nil,
          border = nil,
          win_options = {
            winblend = 0,
          },
        },
        -- Configuration for the floating progress window
        progress = {
          max_width = 0.9,
          min_width = { 40, 0.4 },
          width = nil,
          max_height = { 10, 0.9 },
          min_height = { 5, 0.1 },
          height = nil,
          border = nil,
          minimized_border = 'none',
          win_options = {
            winblend = 0,
          },
        },
        -- Configuration for the floating SSH window
        ssh = {
          border = nil,
        },
        -- Configuration for the floating keymaps help window
        keymaps_help = {
          border = nil,
        },
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
