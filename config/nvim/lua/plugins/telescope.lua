return {
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons' },
    },
    config = function()
      local pickers = require 'telescope.pickers'
      local finders = require 'telescope.finders'
      local actions = require 'telescope.actions'
      local make_entry = require 'telescope.make_entry'
      local conf = require('telescope.config').values

      local select_one_or_multi = function(prompt_bufnr)
        local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
        local multi = picker:get_multi_selection()
        if not vim.tbl_isempty(multi) then
          require('telescope.actions').close(prompt_bufnr)
          for _, j in pairs(multi) do
            if j.path ~= nil then
              vim.cmd(string.format('%s %s', 'edit', j.path))
            end
          end
        else
          require('telescope.actions').select_default(prompt_bufnr)
        end
      end

      -- Improved live_multigrep function with proper glob handling
      -- Usage examples:
      -- Search "abc" in all .py files: abc  *.py
      -- Search "abc" in .py files in app folder: abc  *.py  **/app/**
      -- Search "abc" in app folder (any file): abc  **/app/**
      local live_multigrep = function(opts)
        opts = opts or {}
        opts.cwd = opts.cwd or vim.uv.cwd()

        local finder = finders.new_async_job {
          command_generator = function(prompt)
            if not prompt or prompt == '' then
              return nil
            end

            -- Split on two spaces
            local pieces = vim.split(prompt, '  ')
            local args = { 'rg' }

            -- First piece is the search term
            if pieces[1] and pieces[1] ~= '' then
              table.insert(args, '-e')
              table.insert(args, pieces[1])
            end

            -- Remaining pieces are glob patterns
            for i = 2, #pieces do
              if pieces[i] and pieces[i] ~= '' then
                table.insert(args, '-g')
                table.insert(args, pieces[i])
              end
            end

            ---@diagnostic disable-next-line: deprecated
            return vim.tbl_flatten {
              args,
              {
                '--hidden',
                '--no-ignore',
                '--no-ignore-vcs',
                '--no-heading',
                '--with-filename',
                '--line-number',
                '--column',
                '--smart-case',
              },
            }
          end,
          entry_maker = make_entry.gen_from_vimgrep(opts),
          cwd = opts.cwd,
        }

        pickers
          .new(opts, {
            debounce = 100,
            prompt_title = 'Multi Grep (search  glob1  glob2)',
            finder = finder,
            previewer = conf.grep_previewer(opts),
            sorter = require('telescope.sorters').empty(),
          })
          :find()
      end

      require('telescope').setup {
        defaults = {
          file_ignore_patterns = {
            'node_modules',
            '.venv',
            '.git',
            'dist/',
            'build/',
            'target/',
          },
          layout_config = {
            horizontal = {
              width = 0.90,
              preview_width = 0.65,
              results_width = 0.25,
            },
          },
          mappings = {
            n = {
              ['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
            },
            i = {
              ['<CR>'] = select_one_or_multi,
              ['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
            },
          },
          vimgrep_arguments = {
            'rg',
            '--hidden',
            '--no-ignore',
            '--no-ignore-vcs',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
          },
          picker = {
            find_files = {
              hidden = true, -- Show dotfiles
              follow = true, -- Follow symlinks
            },
          },
        },
        pickers = { find_files = { hidden = true, no_ignore = true, no_ignore_parent = true, follow = true } },
        find_command = { 'rg', '--files', '--hidden', '--no-ignore', '--no-ignore-vcs', '--follow' },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
        },
      }

      -- show line number
      vim.api.nvim_create_autocmd('User', {
        pattern = 'TelescopePreviewerLoaded',
        callback = function(args)
          if args.data.filetype ~= 'help' then
            vim.wo.number = true
          elseif args.data.bufname:match '*.csv' then
            vim.wo.wrap = false
          end
        end,
      })

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sg', live_multigrep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sD', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sd', function()
        require('telescope.builtin').diagnostics { bufnr = 0 }
      end, { desc = '[S]earch [D]iagnostics Buffer only' })
      vim.keymap.set('n', '<leader>ss', builtin.resume, { desc = '[S]earch Resume' })
      vim.keymap.set('n', '<leader>sn', ':Telescope notify<CR>', { desc = 'List Notifications' })
      vim.keymap.set('n', 'sb', builtin.buffers, { desc = '[S]earch [B]uffers' })
      vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = '[G]it [S]tatus' })
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })
    end,
  },
}
