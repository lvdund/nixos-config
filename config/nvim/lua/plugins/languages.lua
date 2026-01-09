return {
  {
    'b0o/SchemaStore.nvim',
    lazy = true,
    version = false, -- last release is way too old
  },
  {
    'Saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    opts = {
      completion = {
        crates = {
          enabled = true,
        },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  -- {
  --   'maxandron/goplements.nvim',
  --   ft = 'go',
  --   opts = {
  --     prefix = {
  --       interface = 'implemented by: ',
  --       struct = 'implements: ',
  --     },
  --     display_package = true,
  --     namespace_name = 'goplements',
  --     highlight = 'Goplements',
  --   },
  -- },
  {
    'zgs225/gomodifytags.nvim',
    cmd = { 'GoAddTags', 'GoRemoveTags', 'GoInstallModifyTagsBin' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('gomodifytags').setup()
    end,
  },
}
