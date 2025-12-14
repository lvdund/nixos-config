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
      -- Example 1: search "func" only in file comments.lua
      -- func  *ents.lua
      -- Example 2: search "func" only in folder plugins
      -- func  **/plugins/**
      local live_multigrep = function(opts)
        opts = opts or {}
        opts.cwd = opts.cwd or vim.uv.cwd()

        local finder = finders.new_async_job {
          command_generator = function(prompt)
            if not prompt or prompt == '' then
              return nil
            end

            local pieces = vim.split(prompt, '  ')
            local args = { 'rg' }
            if pieces[1] then
              table.insert(args, '-e')
              table.insert(args, pieces[1])
            end

            if pieces[2] then
              table.insert(args, '-g')
              table.insert(args, pieces[2])
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
            prompt_title = 'Multi Grep',
            finder = finder,
            previewer = conf.grep_previewer(opts),
            sorter = require('telescope.sorters').empty(),
          })
          :find()
      end

      require('telescope').setup {
        defaults = {
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

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require('telescope').load_extension, 'projects')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sg', live_multigrep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>ss', builtin.resume, { desc = '[S]earch Resume' })
      vim.keymap.set('n', '<leader>sn', ':Noice history<CR>', { desc = 'List Notifications' })
      vim.keymap.set('n', '<leader>sp', ':Telescope projects<CR>', { desc = '[S]earch Book[M]arks' })
      vim.keymap.set('n', '<leader>scn', function()
        require('todo-comments').jump_next()
      end, { desc = '[N]ext TODO' })
      vim.keymap.set('n', '<leader>sb', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = 'Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })
    end,
  },
  {
    'ahmedkhalf/project.nvim',
    config = function()
      require('project_nvim').setup {
        patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json', 'go.md' },
      }
    end,
  },
}
