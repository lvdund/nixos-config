local icons = {
  Error = ' ',
  Warn = ' ',
  Hint = ' ',
  Info = ' ',
}

return {
  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    keys = {
      { '<leader>ba', '<Cmd>bufdo bd<CR>', desc = 'Close all Buffer' },
      { '<leader>bc', '<Cmd>bdelete<CR>', desc = 'Close this Buffer' },
      { '<leader>bo', '<Cmd>BufferLineCloseOthers<CR>', desc = 'Close other Buffers' },
      { '[B', '<Cmd>BufferLineMovePrev<CR>', desc = 'Move Buffers Left' },
      { ']B', '<Cmd>BufferLineMoveNext<CR>', desc = 'Move Buffers Right' },
      { '<S-Tab>', '<cmd>bprev<cr>', desc = 'Prev Buffer' },
      { '<Tab>', '<cmd>bnext<cr>', desc = 'Next Buffer' },
    },
    opts = {
      highlights = {
        buffer_selected = {
          bold = true,
          italic = true,
        },
      },

      options = {
        diagnostics = 'nvim_lsp',
        diagnostics_indicator = function(_, _, diag)
          local ret = (diag.error and icons.Error .. diag.error .. ' ' or '') .. (diag.warning and icons.Warn .. diag.warning or '')
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'Neo-tree',
            highlight = 'Directory',
            text_align = 'left',
          },
        },
        hover = {
          enabled = true,
          delay = 200,
          reveal = { 'close' },
        },
        indicator = {
          icon = '▎', -- this should be omitted if indicator style is not 'icon'
          style = 'underline',
        },
      },
    },
  },
  {
    'b0o/incline.nvim',
    dependencies = {
      'SmiteshP/nvim-navic',
      'nvim-web-devicons',
    },
    config = function()
      local helpers = require 'incline.helpers'
      local navic = require 'nvim-navic'
      local devicons = require 'nvim-web-devicons'
      require('incline').setup {
        window = {
          padding = 0,
          margin = { horizontal = 0, vertical = 0 },
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
          if filename == '' then
            filename = '[ 󰡯 ]'
          end
          local ft_icon, ft_color = devicons.get_icon_color(filename)
          local modified = vim.bo[props.buf].modified
          local res = {
            ft_icon and { ' ', ft_icon, ' ', guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or '',
            ' ',
            { filename, gui = modified and 'bold,italic' or 'bold' },
            guibg = '#44406e',
          }
          if props.focused then
            for _, item in ipairs(navic.get_data(props.buf) or {}) do
              table.insert(res, {
                { ' > ', group = 'NavicSeparator' },
                { item.icon, group = 'NavicIcons' .. item.type },
                { item.name, group = 'NavicText' },
              })
            end
          end
          table.insert(res, ' ')
          return res
        end,
      }
    end,
    -- Optional: Lazy load Incline
    event = 'VeryLazy',
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'dracula',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
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
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = {
            {
              function()
                local reg = vim.fn.reg_recording()
                if reg == '' then
                  return ''
                end -- not recording
                return 'record: ' .. reg
              end,
            },
            -- {
            --   'filename',
            --   path = 1,
            --   separator = vim.trim ' ⟩ ',
            --   fmt = function(str)
            --     return str:gsub(package.config:sub(1, 1), '/')
            --   end,
            -- },
          },
          -- lualine_x = { 'filename' },
          -- lualine_y = { 'datetime' },
          lualine_x = {},
          lualine_y = {},
          lualine_z = { 'location' },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
      }
    end,
  },
}
