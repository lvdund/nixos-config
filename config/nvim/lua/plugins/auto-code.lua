return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { lsp_format = 'fallback' }
          vim.cmd 'write'
        end,
        mode = '',
        desc = '[F]ormat buffer and save',
      },
    },
    opts = {
      notify_on_error = true,
      formatters_by_ft = {
        lua = { 'stylua' },
        go = { 'gofmt', 'goimports' },
      },
      format_on_save = false,
      -- format_on_save = {
      --   timeout_ms = 500,
      --   lsp_format = 'fallback',
      -- },
    },
  },
  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {},
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'none',
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide' },
        ['<CR>'] = { 'accept', 'fallback' },

        ['<S-Tab>'] = { 'select_prev', 'fallback' },
        ['<Tab>'] = { 'select_next', 'fallback' },

        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

        ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
      },

      appearance = {
        nerd_font_variant = 'normal',
        kind_icons = {
          Text = '󰉿 ',
          Method = ' ',
          Function = '󰊕',
          Constructor = '󰒓 ',
          Field = ' ',
          Variable = '󰆦 ',
          Property = '󰖷 ',
          Class = ' ',
          Interface = ' ',
          Struct = '󱡠 ',
          Module = '󰅩 ',
          Unit = '󰪚 ',
          Value = ' ',
          Enum = ' ',
          EnumMember = ' ',
          Keyword = ' ',
          Constant = '󰏿',
          Snippet = ' ',
          Color = '󰏘 ',
          File = '󰈔 ',
          Reference = '󰬲 ',
          Folder = '󰉋 ',
          Event = '󱐋',
          Operator = '󰪚 ',
          TypeParameter = '󰬛 ',
          Error = '󰏭 ',
          Warning = ' ',
          Information = '󰋼 ',
          Hint = '',
        },
      },

      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = 'rounded',
            winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpDocCursorLine,Search:None',
          },
        },
        menu = {
          border = 'rounded',
          draw = { gap = 2 },
          winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None',
        },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },

      snippets = { preset = 'luasnip' },
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = 'lua' },
      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = false },
    },
  },
}
