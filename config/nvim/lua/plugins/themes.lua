return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        flavour = 'macchiato',
        background = { -- :h background
          light = 'latte',
          dark = 'mocha',
        },
        transparent_background = false, -- disables setting the background color.
        show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
        term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
        dim_inactive = {
          enabled = true, -- dims the background color of inactive window
          shade = 'dark',
          percentage = 0.85, -- percentage of the shade to apply to the inactive window
        },
        no_italic = false,
        no_bold = false,
        no_underline = false,
        styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
          comments = { 'italic' },
          conditionals = { 'italic' },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
          -- miscs = {}, -- Uncomment to turn off hard-coded styles
        },
        color_overrides = {
          macchiato = {
            rosewater = '#F5B8AB',
            flamingo = '#F29D9D',
            pink = '#AD6FF7',
            mauve = '#FF8F40',
            red = '#E66767',
            maroon = '#EB788B',
            peach = '#FAB770',
            yellow = '#FACA64',
            green = '#70CF67',
            teal = '#4CD4BD',
            sky = '#61BDFF',
            sapphire = '#4BA8FA',
            blue = '#00BFFF',
            lavender = '#00BBCC',
            text = '#C1C9E6',
            subtext1 = '#A3AAC2',
            subtext0 = '#8E94AB',
            overlay2 = '#7D8296',
            overlay1 = '#676B80',
            overlay0 = '#464957',
            surface2 = '#3A3D4A',
            surface1 = '#2F313D',
            surface0 = '#1D1E29',
            -- base = '#0b0b12',
            -- mantle = '#11111a',
            -- crust = '#191926',
            base = '#000000',
            mantle = '#0A0A0A',
            crust = '#101010',
          },
        },
        highlight_overrides = {
          all = function(colors)
            local mocha = require('catppuccin.palettes').get_palette 'mocha'
            return {
              CurSearch = { bg = colors.sky },
              IncSearch = { bg = colors.sky },
              CursorLineNr = { fg = colors.blue, style = { 'bold' } },
              DashboardFooter = { fg = colors.overlay0 },
              TreesitterContextBottom = { style = {} },
              WinSeparator = { fg = colors.overlay0, style = { 'bold' } },
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
            Comment = { fg = colors.flamingo },
            TabLineSel = { bg = colors.pink },
            CmpBorder = { fg = colors.surface2 },
            Pmenu = { bg = colors.none },
          }
        end,
        default_integrations = true,
        integrations = {
          cmp = true,
          gitsigns = true,
          neotree = true,
          treesitter = true,
          notify = false,
          which_key = true,
        },
      }
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
}
