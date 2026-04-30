vim.pack.add({
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
})

local function get_keymap()
  if vim.opt.iminsert:get() > 0 and vim.b.keymap_name then
    return "" .. vim.b.keymap_name
  end
  return "en"
end

require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "dracula",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {
      statusline = { "neo-tree" },
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = true,
    refresh = {
      statusline = 100,
      tabline = 100,
      winbar = 100,
    },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { { get_keymap } },
    lualine_c = {
      {
        "filename",
        path = 1,
      },
    },
    lualine_x = {
      {
        function()
          local reg = vim.fn.reg_recording()
          if reg == "" then
            return ""
          end
          return "record: " .. reg
        end,
      },
      {
        "lsp_status",
        icon = "",
        symbols = {
          spinner = { "", "", "", "", "", "", "", "", "", "" },
          done = "",
          separator = " ",
        },
        ignore_lsp = {},
        show_name = true,
      },
    },
    lualine_y = {
      {
        "diff",
        symbols = { added = "✚", modified = "~", removed = "✖" },
        source = nil,
      },
      "diagnostics",
    },
    lualine_z = { "branch" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        "filename",
        path = 1,
      },
    },
    lualine_x = {},
    lualine_y = {
      {
        "diff",
        symbols = { added = "✚", modified = "~", removed = "✖" },
        source = nil,
      },
      "diagnostics",
    },
    lualine_z = { "branch" },
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {},
})
