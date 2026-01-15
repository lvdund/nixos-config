return {
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {},
  },
  {
    'hat0uma/csvview.nvim',
    ---@module "csvview"
    ---@type CsvView.Options
    opts = {
      parser = { comments = { '#', '//' } },
    },
    cmd = { 'CsvViewEnable', 'CsvViewDisable', 'CsvViewToggle' },
    config = function() end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
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
  {
    'brenoprata10/nvim-highlight-colors',
    event = 'BufReadPre',
    opts = {
      render = 'background',
      enable_hex = true,
      enable_short_hex = true,
      enable_rgb = true,
      enable_hsl = true,
      enable_hsl_without_function = true,
      enable_ansi = true,
      enable_var_usage = true,
      enable_tailwind = true,
    },
  },
}
