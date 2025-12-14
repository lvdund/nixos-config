return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
  },
  {
    'ya2s/nvim-cursorline',
    config = function()
      require('nvim-cursorline').setup {
        cursorline = {
          enable = true,
          timeout = 300,
          number = false,
        },
        cursorword = {
          enable = true,
          min_length = 3,
          hl = { underline = true },
        },
      }
    end,
  },
  {
    'karb94/neoscroll.nvim',
    opts = function()
      local neoscroll = require 'neoscroll'
      local keymap = {
        ['<PageUp>'] = function()
          neoscroll.scroll(-0.2, { move_cursor = false, duration = 70 })
        end,
        ['<PageDown>'] = function()
          neoscroll.scroll(0.2, { move_cursor = false, duration = 70 })
        end,
      }

      for key, func in pairs(keymap) do
        vim.keymap.set({ 'n', 'v', 'x', 'i' }, key, func)
      end
    end,
  },
  {
    'mawkler/refjump.nvim',
    event = 'LspAttach', -- Uncomment to lazy load
    opts = {
      keymaps = {
        enable = true,
        next = ']r', -- Keymap to jump to next LSP reference
        prev = '[r', -- Keymap to jump to previous LSP reference
      },
      highlights = {
        enable = true, -- Highlight the LSP references on jump
        auto_clear = true, -- Automatically clear highlights when cursor moves
      },
      integrations = {
        demicolon = {
          enable = true, -- Make `]r`/`[r` repeatable with `;`/`,` using demicolon.nvim
        },
      },
      verbose = true, -- Print message if no reference is found
    },
  },
}
