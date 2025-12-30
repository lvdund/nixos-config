-- autopairs
-- https://github.com/windwp/nvim-autopairs

return {
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {},
  },
  {
    'NStefan002/visual-surround.nvim',
    config = function()
      require('visual-surround').setup {
        use_default_keymaps = true,
        delete_surr = 'ds', -- Delete surround mapping
        surround_chars = { '{', '}', '[', ']', '(', ')', "'", '"', '`', '<', '>' },
        enable_wrapped_deletion = false,
        exit_visual_mode = true,
      }
    end,
  },
  {
    'mg979/vim-visual-multi',
    branch = 'master',
    init = function()
      vim.g.VM_theme = 'iceblue'
      vim.g.VM_highlight_matches = 'underline'
      vim.g.VM_default_mappings = 0
      vim.g.VM_maps = {
        ['Find Under'] = '<C-d>', -- Ctrl+D select next
        ['Find Subword Under'] = '<C-d>',
        ['Select All'] = '<M-a>',
        ['Skip Region'] = '<C-x>',
        ['Remove Region'] = 'q',
      }
    end,
  },
}
