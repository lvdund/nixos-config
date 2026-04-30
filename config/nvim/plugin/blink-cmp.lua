vim.pack.add({
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.x") },
})

require("blink.cmp").setup({
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
      auto_show = true,
    },
    ghost_text = {
      enabled = true,
      show_with_menu = false,
    },
  },

  fuzzy = {
    implementation = 'lua',
    sorts = {
      'exact',
      -- defaults
      'score',
      'sort_text',
    },
  },
  -- Shows a signature help window while you type arguments for a function
  signature = {
    enabled = true,
    window = {
      direction_priority = { 's', 'n' },
    },
  },
})
