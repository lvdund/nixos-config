return {
  specs = {
    { src = 'https://github.com/folke/noice.nvim' },
    { src = 'https://github.com/nvim-lualine/lualine.nvim' },
    { src = 'https://github.com/MunifTanjim/nui.nvim' },
    { src = 'https://github.com/rcarriga/nvim-notify' },
    { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  },
  setup = function()
    require('noice').setup({
      lsp = {
        signature = { enabled = false },
        hover = { enabled = true, view = 'hover', opts = { border = 'rounded' } },
        documentation = { view = 'hover', opts = { border = { style = 'rounded', padding = { 0, 1 } } } },
      },
      cmdline = { enabled = true, view = 'cmdline_popup' },
      messages = { enabled = true, view = 'mini' },
      popupmenu = { enabled = true, backend = 'nui' },
    })
    vim.opt.cmdheight = 0
    vim.opt.laststatus = 3

    local function get_keymap()
      if vim.opt.iminsert:get() > 0 and vim.b.keymap_name then
        return ' ' .. vim.b.keymap_name
      end
      return ' en'
    end

    require('lualine').setup({
      options = {
        icons_enabled = true, theme = 'dracula',
        component_separators = { left = '┃', right = '┃' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = { statusline = { 'neo-tree' }, winbar = {} },
        always_divide_middle = true, always_show_tabline = true, globalstatus = false,
        refresh = { statusline = 100, tabline = 100, winbar = 100 },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { { get_keymap } },
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = {
          { function()
            local reg = vim.fn.reg_recording()
            if reg == '' then return '' end
            return 'record: ' .. reg
          end },
          { 'lsp_status', icon = '',
            symbols = { spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }, done = '✓', separator = ' ' },
            ignore_lsp = {}, show_name = true },
        },
        lualine_y = {},
        lualine_z = { 'branch' },
      },
      inactive_sections = {
        lualine_a = {}, lualine_b = {},
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = {}, lualine_y = {}, lualine_z = { 'branch' },
      },
      tabline = {}, winbar = {}, inactive_winbar = {}, extensions = {},
    })
  end,
}
