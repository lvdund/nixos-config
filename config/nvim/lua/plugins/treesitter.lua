return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = {
        'go', 'gomod', 'gowork', 'gosum',
        'lua', 'vim', 'vimdoc',
        'bash', 'fish',
        'python', 'rust', 'c', 'cpp',
        'javascript', 'typescript', 'tsx', 'json',
        'yaml', 'toml', 'markdown', 'markdown_inline',
        'dockerfile', 'regex',
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
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
  }
}
