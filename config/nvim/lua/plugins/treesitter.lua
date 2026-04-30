return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      fold = { enable = true },
    },
    config = function(_, opts)
      -- Try treesitter folding first, fallback to indent
      vim.o.foldmethod = 'expr'
      vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.o.foldtext = '' -- Use default foldtext
      -- Better fold display
      -- vim.opt.fillchars:append({ fold = ' ', foldopen = '', foldsep = ' ', foldclose = '' })
      -- vim.o.foldcolumn = '1' -- Show fold column
      vim.o.foldlevel = 99 -- Start with all folds open
      vim.o.foldlevelstart = 99 -- Start with all folds open for new files
      vim.o.foldenable = true -- Enable folding

      require('nvim-treesitter.config').setup(opts)

      vim.api.nvim_create_autocmd('FileType', {
        pattern = '*',
        callback = function(args)
          local buf = args.buf
          local ft = vim.bo[buf].filetype
          pcall(vim.treesitter.start, buf, ft)
        end,
      })

      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
          local ft = vim.bo[buf].filetype
          if ft ~= '' then
            pcall(vim.treesitter.start, buf, ft)
          end
        end
      end
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      enable = true,
      max_lines = 3,
      mode = 'cursor',
    },
  },
}
