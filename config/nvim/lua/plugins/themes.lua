return {
  specs = {
    { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
    { src = 'https://github.com/brenoprata10/nvim-highlight-colors' },
  },
  setup = function()
    require('catppuccin').setup({
      flavour = 'macchiato',
      background = { light = 'latte', dark = 'mocha' },
      transparent_background = false,
      show_end_of_buffer = false,
      term_colors = true,
      dim_inactive = { enabled = true, shade = 'dark', percentage = 0.85 },
      no_italic = false,
      no_bold = false,
      no_underline = false,
      styles = {
        comments = { 'italic' },
        conditionals = { 'italic' },
        loops = {}, functions = {}, keywords = {}, strings = {},
        variables = {}, numbers = {}, booleans = {}, properties = {},
        types = {}, operators = {},
      },
      color_overrides = {
        macchiato = {
          rosewater = '#F5B8AB', flamingo = '#F29D9D', pink = '#AD6FF7',
          mauve = '#FF8F40', red = '#E66767', maroon = '#EB788B',
          peach = '#FAB770', yellow = '#FACA64', green = '#70CF67',
          teal = '#4CD4BD', sky = '#61BDFF', sapphire = '#4BA8FA',
          blue = '#00BFFF', lavender = '#00BBCC', text = '#C1C9E6',
          subtext1 = '#A3AAC2', subtext0 = '#8E94AB', overlay2 = '#7D8296',
          overlay1 = '#676B80', overlay0 = '#464957', surface2 = '#3A3D4A',
          surface1 = '#2F313D', surface0 = '#1D1E29', base = '#000000',
          mantle = '#0A0A0A', crust = '#101010',
        },
      },
      highlight_overrides = {
        all = function(colors)
          return {
            CurSearch = { bg = colors.sky }, IncSearch = { bg = colors.sky },
            CursorLineNr = { fg = colors.blue, style = { 'bold' } },
            DashboardFooter = { fg = colors.overlay0 },
            TreesitterContextBottom = { style = {} },
            ['@markup.italic'] = { fg = colors.blue, style = { 'italic' } },
            ['@markup.strong'] = { fg = colors.blue, style = { 'bold' } },
            Headline = { style = { 'bold' } },
            Headline1 = { fg = colors.blue, style = { 'bold' } },
            Headline2 = { fg = colors.pink, style = { 'bold' } },
            Headline3 = { fg = colors.lavender, style = { 'bold' } },
            Headline4 = { fg = colors.green, style = { 'bold' } },
            Headline5 = { fg = colors.peach, style = { 'bold' } },
            Headline6 = { fg = colors.flamingo, style = { 'bold' } },
            rainbow1 = { fg = colors.blue, style = { 'bold' } },
            rainbow2 = { fg = colors.pink, style = { 'bold' } },
            rainbow3 = { fg = colors.lavender, style = { 'bold' } },
            rainbow4 = { fg = colors.green, style = { 'bold' } },
            rainbow5 = { fg = colors.peach, style = { 'bold' } },
            rainbow6 = { fg = colors.flamingo, style = { 'bold' } },
          }
        end,
      },
      custom_highlights = function(colors)
        return {
          TabLineSel = { bg = colors.pink },
          CmpBorder = { fg = colors.surface1 },
          FloatBorder = { fg = colors.teal, bg = colors.base },
          NormalFloat = { bg = colors.base },
          Pmenu = { bg = colors.surface0 },
          WinSeparator = { fg = colors.pink, style = { 'bold' } },
          VertSplit = { fg = colors.pink, style = { 'bold' } },
          CmpItemAbbrDeprecated = { fg = colors.overlay2, style = { 'strikethrough' } },
          CmpItemAbbrMatch = { fg = colors.blue, style = { 'bold' } },
          CmpItemAbbrMatchFuzzy = { fg = colors.blue, style = { 'bold' } },
          CmpItemKind = { fg = colors.mauve },
          CmpItemMenu = { fg = colors.subtext1 },
          CmpItemKindSnippet = { fg = colors.mauve },
          CmpDocBorder = { fg = colors.surface1, bg = colors.base },
          LspSignatureActiveParameter = { bg = colors.surface1, style = { 'bold', 'italic' } },
          SignatureActiveParameter = { bg = colors.surface1, style = { 'bold', 'italic' } },
          CmpSignatureActiveParameter = { bg = colors.surface1, style = { 'bold', 'italic' } },
        }
      end,
      default_integrations = true,
      integrations = {
        cmp = true, gitsigns = true, neotree = true, treesitter = true,
        notify = false, which_key = true,
      },
    })
    vim.cmd.colorscheme('catppuccin')
    require('nvim-highlight-colors').setup({
      render = 'background', enable_hex = true, enable_short_hex = true,
      enable_rgb = true, enable_hsl = true, enable_hsl_without_function = true,
      enable_ansi = true, enable_var_usage = true, enable_tailwind = true,
    })
  end,
}
