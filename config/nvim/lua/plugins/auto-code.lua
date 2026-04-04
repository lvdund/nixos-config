return {
  specs = {
    { src = 'https://github.com/stevearc/conform.nvim' },
    { src = 'https://github.com/saghen/blink.cmp'},
    { src = 'https://github.com/L3MON4D3/LuaSnip'},
    { src = 'https://github.com/folke/lazydev.nvim' },
  },
  setup = function()
    require('conform').setup {
      notify_on_error = true,
      formatters_by_ft = {
        lua = { 'stylua' },
        go = { 'gofmt', 'goimports' },
        rust = { 'rustfmt', lsp_format = 'fallback' },
        nix = { 'alejandra' },
        python = { 'black' },
        dockerfile = { 'dockerfmt' },
        yaml = { 'yamlfmt' },
        json = { lsp_format = 'fallback' },
        jsonc = { lsp_format = 'fallback' },
      },
      format_on_save = false,
    }
    vim.keymap.set('', 'gf', function()
      require('conform').format { lsp_format = 'fallback' }
      vim.cmd 'write'
    end, { desc = '[F]ormat buffer and save' })

    require('blink.cmp').setup {
      keymap = {
        preset = 'none',
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide' },
        ['<CR>'] = { 'accept', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
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
          window = { border = 'rounded', winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpDocCursorLine,Search:None' },
        },
        menu = {
          border = 'rounded',
          draw = { gap = 2 },
          winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None',
          auto_show = true,
        },
        ghost_text = { enabled = true, show_with_menu = false },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = { lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 } },
      },
      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'lua', sorts = { 'exact', 'score', 'sort_text' } },
      signature = { enabled = true, window = { direction_priority = { 's', 'n' } } },
    }
    require('lazydev').setup()
  end,
}
