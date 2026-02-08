-- local icons = {
--   Error = ' ',
--   Warn = ' ',
--   Hint = ' ',
--   Info = ' ',
-- }

return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
      'lewis6991/gitsigns.nvim',
    },
    lazy = false,
    keys = {
      { '\\', '<Cmd>Neotree toggle position=left reveal_force_cwd<CR>', desc = 'Neotree toggle', silent = true },
      { '<C-e>', '<Cmd>Neotree toggle position=float reveal_force_cwd<CR>', desc = 'Neotree', silent = true },
    },
    opts = {
      default_component_configs = {
        container = {
          enable_character_fade = true,
        },
        git_status = {
          symbols = {
            -- Change type
            added = '󰷬 ',
            modified = '󰲶 ',
            deleted = '󰷩 ',
            renamed = '󰁕',
            -- Status type
            untracked = '',
            ignored = ' ',
            unstaged = '✗',
            staged = ' ',
            conflict = ' ',
          },
        },
      },
      source_selector = {
        lualine = false,
      },
      filesystem = {
        window = {
          width = 30,
          mappings = {
            -- ['\\'] = 'close_window',
            ['l'] = 'open',
            ['h'] = 'close_node',
            ['d'] = 'trash_file',
            ['u'] = 'restore_from_trash',
            ['R'] = 'open_trash',
          },
        },
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false,
          hide_by_name = {},
          hide_by_pattern = {},
          always_show = { '.gitignored' },
          always_show_by_pattern = { '.env*' },
        },
        follow_current_file = {
          enabled = true,
          leave_dirs_open = true,
        },
        bind_to_cwd = true,
        cwd_target = {
          sidebar = 'global',
          current = 'global',
        },
      },
      commands = {
        trash_file = function(state)
          local inputs = require 'neo-tree.ui.inputs'
          local path = state.tree:get_node().path
          local msg = 'Are you sure you want to trash ' .. path
          inputs.confirm(msg, function(confirmed)
            if not confirmed then
              return
            end

            vim.fn.system { 'trash', vim.fn.fnameescape(path) }
            require('neo-tree.sources.manager').refresh(state.name)
          end)
        end,
        open_trash = function(_)
          local trash_path = os.getenv 'HOME' .. '/.local/share/Trash/files'
          vim.cmd('Neotree ' .. trash_path)
        end,
        restore_from_trash = function(state)
          local path = state.tree:get_node().path
          local trash_path = os.getenv 'HOME' .. '/.local/share/Trash/files'

          -- Check if we're in the trash directory
          if not path:find(trash_path, 1, true) then
            vim.notify('Not in trash directory. Navigate to trash first (press R).', vim.log.levels.WARN)
            return
          end

          local filename = vim.fn.fnamemodify(path, ':t')
          local inputs = require 'neo-tree.ui.inputs'
          local msg = 'Restore "' .. filename .. '" from trash?'

          inputs.confirm(msg, function(confirmed)
            if not confirmed then
              return
            end

            -- Use trash-restore with echo to auto-select the file
            -- We need to find the index of the file in trash-restore list
            -- local result = vim.fn.system 'trash-restore 2>/dev/null <<< "0"'

            -- Alternative: use gio trash to restore
            local info_file = os.getenv 'HOME' .. '/.local/share/Trash/info/' .. filename .. '.trashinfo'
            local info_handle = io.open(info_file, 'r')

            if info_handle then
              local content = info_handle:read '*all'
              info_handle:close()

              local original_path = content:match 'Path=([^\n]+)'
              if original_path then
                -- URL decode the path
                original_path = original_path:gsub('%%(%x%x)', function(h)
                  return string.char(tonumber(h, 16))
                end)

                -- Move file back to original location
                local success = os.rename(path, original_path)
                if success then
                  -- Remove the .trashinfo file
                  os.remove(info_file)
                  vim.notify('Restored: ' .. original_path, vim.log.levels.INFO)
                  require('neo-tree.sources.manager').refresh(state.name)
                else
                  -- Try with mv command if os.rename fails (cross-device)
                  vim.fn.system { 'mv', path, original_path }
                  os.remove(info_file)
                  vim.notify('Restored: ' .. original_path, vim.log.levels.INFO)
                  require('neo-tree.sources.manager').refresh(state.name)
                end
              else
                vim.notify('Could not find original path in trashinfo', vim.log.levels.ERROR)
              end
            else
              vim.notify('Could not find trashinfo file for: ' .. filename, vim.log.levels.ERROR)
            end
          end)
        end,
      },
    },
    -- Set up autocommand to change to project root
    config = function(_, opts)
      -- Function to find git root
      local function get_git_root()
        local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
        if vim.v.shell_error == 0 and git_root then
          return git_root
        end
        return nil
      end

      -- Auto change to git root when opening files
      vim.api.nvim_create_autocmd('BufEnter', {
        group = vim.api.nvim_create_augroup('NeoTreeGitRoot', { clear = true }),
        pattern = '*',
        callback = function()
          -- Skip if neo-tree buffer
          if vim.bo.filetype == 'neo-tree' then
            return
          end

          local git_root = get_git_root()
          if git_root and vim.fn.getcwd() ~= git_root then
            vim.cmd('cd ' .. git_root)
          end
        end,
      })

      require('neo-tree').setup(opts)
    end,
  },
  {
    'b0o/incline.nvim',
    config = function()
      local devicons = require 'nvim-web-devicons'
      require('incline').setup {
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
          if filename == '' then
            filename = '[No Name]'
          end
          local ft_icon, ft_color = devicons.get_icon_color(filename)

          local function get_git_diff()
            local icons = { added = '+', changed = '~', removed = '-' }
            local groups = { added = 'GitSignsAdd', changed = 'GitSignsChange', removed = 'GitSignsDelete' }
            local signs = vim.b[props.buf].gitsigns_status_dict
            local labels = {}
            if signs == nil then
              return labels
            end
            for name, icon in pairs(icons) do
              if tonumber(signs[name]) and signs[name] > 0 then
                table.insert(labels, { icon .. signs[name] .. ' ', group = groups[name] })
              end
            end
            if #labels > 0 then
              table.insert(labels, { '┊ ' })
            end
            return labels
          end
          local function get_diagnostic_label()
            local icons = { error = '', warn = ' ', info = ' ', hint = '󰌶' }
            local label = {}

            for severity, icon in pairs(icons) do
              local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
              if n > 0 then
                table.insert(label, { icon .. n .. ' ', group = 'DiagnosticSign' .. severity })
              end
            end
            if #label > 0 then
              table.insert(label, { '┊ ' })
            end
            return label
          end

          return {
            { get_diagnostic_label() },
            { get_git_diff() },
            { (ft_icon or '') .. ' ', guifg = ft_color, guibg = 'none' },
            { filename .. ' ', gui = vim.bo[props.buf].modified and 'bold,italic' or 'bold' },
            -- { '┊  ' .. vim.api.nvim_win_get_number(props.win), group = 'DevIconWindows' },
          }
        end,
      }
    end,
    -- Optional: Lazy load Incline
    event = 'VeryLazy',
  },
  -- {
  --   'akinsho/bufferline.nvim',
  --   event = 'VeryLazy',
  --   enabled = false,
  --   keys = {
  --     { '<leader>ba', '<Cmd>bufdo bd<CR>', desc = 'Close all Buffer' },
  --     { '[B', '<Cmd>BufferLineMovePrev<CR>', desc = 'Move Buffers Left' },
  --     { ']B', '<Cmd>BufferLineMoveNext<CR>', desc = 'Move Buffers Right' },
  --     { '<leader>bo', '<Cmd>BufferLineCloseOthers<CR>', desc = 'Close Other Buffer' },
  --   },
  --   opts = {
  --     highlights = {
  --       buffer_selected = {
  --         bold = true,
  --         italic = true,
  --       },
  --     },
  --     options = {
  --       diagnostics = 'nvim_lsp',
  --       diagnostics_indicator = function(_, _, diag)
  --         local ret = (diag.error and icons.Error .. diag.error .. ' ' or '') .. (diag.warning and icons.Warn .. diag.warning or '')
  --         return vim.trim(ret)
  --       end,
  --       offsets = {
  --         {
  --           filetype = 'neo-tree',
  --           text = 'Neo-tree',
  --           highlight = 'Directory',
  --           text_align = 'left',
  --         },
  --       },
  --       hover = {
  --         enabled = true,
  --         delay = 200,
  --         reveal = { 'close' },
  --       },
  --       indicator = {
  --         icon = '▎', -- this should be omitted if indicator style is not 'icon'
  --         style = 'underline',
  --       },
  --     },
  --   },
  -- },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {},
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    config = function()
      require('noice').setup {
        lsp = {
          signature = {
            enabled = false,
          },
          hover = {
            enabled = true,
            view = 'hover',
            opts = { border = 'rounded' },
          },
          documentation = {
            view = 'hover',
            opts = {
              border = {
                style = 'rounded',
                padding = { 0, 1 },
              },
            },
          },
        },
        cmdline = {
          enabled = true,
          view = 'cmdline_popup', -- This puts the :command bar in the middle
        },
        messages = {
          enabled = true,
          view = 'mini', -- Shifts "Written" messages to a small corner popup
        },
        popupmenu = {
          enabled = true, -- Use a fancy floating menu for completions
          backend = 'nui',
        },
      }
      vim.opt.cmdheight = 0
      vim.opt.laststatus = 3
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local function get_keymap()
        if vim.opt.iminsert:get() > 0 and vim.b.keymap_name then
          return ' ' .. vim.b.keymap_name
        end
        return ' en'
      end

      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'dracula',
          component_separators = { left = '┃', right = '┃' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {
            statusline = { 'neo-tree' },
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          always_show_tabline = true,
          globalstatus = false,
          refresh = {
            statusline = 100,
            tabline = 100,
            winbar = 100,
          },
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { { get_keymap } },
          lualine_c = {
            {
              'filename',
              path = 1,
            },
          },
          lualine_x = {
            {
              function()
                local reg = vim.fn.reg_recording()
                if reg == '' then
                  return ''
                end -- not recording
                return 'record: ' .. reg
              end,
            },
            {
              'lsp_status',
              icon = '',
              symbols = {
                spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
                done = '✓',
                separator = ' ',
              },
              ignore_lsp = {},
              show_name = true,
            },
          },
          lualine_y = {
            -- {
            --   'diff',
            --   symbols = { added = '+', modified = '~', removed = '-' },
            --   source = nil,
            -- },
            -- 'diagnostics',
            -- {
            --   'filetype',
            --   icon_only = true,
            -- },
          },
          lualine_z = { 'branch' },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { {
            'filename',
            path = 1,
          } },
          lualine_x = {},
          lualine_y = {
            -- {
            --   'diff',
            --   symbols = { added = '+', modified = '~', removed = '-' },
            --   source = nil,
            -- },
            -- 'diagnostics',
            -- {
            --   'filetype',
            --   icon_only = true,
            -- },
          },
          lualine_z = { 'branch' },
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
      }
    end,
  },
}
