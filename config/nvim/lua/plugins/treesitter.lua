return {
  specs = {
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },
  },
  setup = function()
    vim.o.foldmethod = 'expr'
    vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.o.foldtext = ''
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    require('nvim-treesitter.config').setup({
      ensure_installed = {
        'go', 'gomod', 'gowork', 'gosum',
        'lua', 'vim', 'vimdoc', 'bash', 'fish',
        'python', 'rust', 'c', 'cpp',
        'javascript', 'typescript', 'tsx', 'json',
        'yaml', 'toml', 'markdown', 'markdown_inline',
        'dockerfile', 'regex',
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      fold = { enable = true },
    })

    vim.api.nvim_create_autocmd('FileType', {
      pattern = '*',
      callback = function(args)
        pcall(vim.treesitter.start, args.buf, vim.bo[args.buf].filetype)
      end,
    })

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) then
        local ft = vim.bo[buf].filetype
        if ft ~= '' then pcall(vim.treesitter.start, buf, ft) end
      end
    end

    require('treesitter-context').setup({ enable = true, max_lines = 3, mode = 'cursor' })
  end,
}
