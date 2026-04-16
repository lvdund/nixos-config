return {
  -- {
  --   'b0o/incline.nvim',
  --   config = function()
  --     local devicons = require 'nvim-web-devicons'
  --     require('incline').setup {
  --       render = function(props)
  --         local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
  --         if filename == '' then
  --           filename = '[No Name]'
  --         end
  --         local ft_icon, ft_color = devicons.get_icon_color(filename)
  --
  --         local function get_git_diff()
  --           local icons = { added = '+', changed = '~', removed = '-' }
  --           local groups = { added = 'GitSignsAdd', changed = 'GitSignsChange', removed = 'GitSignsDelete' }
  --           local signs = vim.b[props.buf].gitsigns_status_dict
  --           local labels = {}
  --           if signs == nil then
  --             return labels
  --           end
  --           for name, icon in pairs(icons) do
  --             if tonumber(signs[name]) and signs[name] > 0 then
  --               table.insert(labels, { icon .. signs[name] .. ' ', group = groups[name] })
  --             end
  --           end
  --           if #labels > 0 then
  --             table.insert(labels, { '┊ ' })
  --           end
  --           return labels
  --         end
  --         local function get_diagnostic_label()
  --           local icons = { error = '', warn = '󱈸', info = '', hint = '󰌶' }
  --           local label = {}
  --
  --           for severity, icon in pairs(icons) do
  --             local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
  --             if n > 0 then
  --               table.insert(label, { icon .. n .. ' ', group = 'DiagnosticSign' .. severity })
  --             end
  --           end
  --           if #label > 0 then
  --             table.insert(label, { '┊ ' })
  --           end
  --           return label
  --         end
  --
  --         return {
  --           { get_diagnostic_label() },
  --           { get_git_diff() },
  --           { (ft_icon or '') .. ' ', guifg = ft_color, guibg = 'none' },
  --           { filename .. ' ', gui = vim.bo[props.buf].modified and 'bold,italic' or 'bold' },
  --           -- { '┊  ' .. vim.api.nvim_win_get_number(props.win), group = 'DevIconWindows' },
  --         }
  --       end,
  --     }
  --   end,
  --   -- Optional: Lazy load Incline
  --   event = 'VeryLazy',
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
          view = 'cmdline',
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
            {
              'diff',
              symbols = { added = '+', modified = '~', removed = '-' },
              source = nil,
            },
            'diagnostics',
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
            {
              'diff',
              symbols = { added = '+', modified = '~', removed = '-' },
              source = nil,
            },
            'diagnostics',
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
