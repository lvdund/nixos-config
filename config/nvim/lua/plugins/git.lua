return {
  specs = {
    { src = 'https://github.com/akinsho/git-conflict.nvim' },
    { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  },
  setup = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'GitConflictDetected',
      callback = function()
        vim.notify('Conflict detected in ' .. vim.fn.expand('<afile>'))
      end,
    })
    require('git-conflict').setup({
      default_mappings = true, default_commands = true,
      disable_diagnostics = true, list_opener = 'copen',
      highlights = { incoming = 'DiffText', current = 'DiffAdd' },
    })
    vim.api.nvim_set_hl(0, 'GitConflictIncoming', { bg = '#293919' })
    vim.api.nvim_set_hl(0, 'GitConflictIncomingLabel', { bold = true, bg = '#698F3F' })
    vim.keymap.set('n', '<Leader>gcb', '<cmd>GitConflictChooseBoth<CR>', { desc = 'choose both' })
    vim.keymap.set('n', '<Leader>gcn', '<cmd>GitConflictNextConflict<CR>', { desc = 'move to next conflict' })
    vim.keymap.set('n', '<Leader>gcc', '<cmd>GitConflictChooseOurs<CR>', { desc = 'choose current' })
    vim.keymap.set('n', '<Leader>gcp', '<cmd>GitConflictPrevConflict<CR>', { desc = 'move to prev conflict' })
    vim.keymap.set('n', '<Leader>gci', '<cmd>GitConflictChooseTheirs<CR>', { desc = 'choose incoming' })

    require('gitsigns').setup({
      signs = {
        add = { text = '┃' }, change = { text = '┃' }, delete = { text = '_' },
        topdelete = { text = '‾' }, changedelete = { text = '~' }, untracked = { text = '┆' },
      },
      signs_staged = {
        add = { text = '┃' }, change = { text = '┃' }, delete = { text = '_' },
        topdelete = { text = '‾' }, changedelete = { text = '~' }, untracked = { text = '┆' },
      },
      signs_staged_enable = true, signcolumn = true, numhl = false, linehl = false,
      word_diff = false, watch_gitdir = { follow_files = true },
      auto_attach = true, attach_to_untracked = false, current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true, virt_text_pos = 'eol', delay = 100,
        ignore_whitespace = false, virt_text_priority = 100, use_focus = true,
      },
      current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
      sign_priority = 6, update_debounce = 100, status_formatter = nil,
      max_file_length = 40000,
      preview_config = { style = 'minimal', relative = 'cursor', row = 0, col = 1 },
      on_attach = function(bufnr)
        if vim.bo[bufnr].filetype == 'neo-tree' then return end
        local gitsigns = require('gitsigns')
        local function map(mode, l, r, o)
          o = o or {}
          o.buffer = bufnr
          vim.keymap.set(mode, l, r, o)
        end
        map('n', ']c', function()
          if vim.wo.diff then vim.cmd.normal({ ']c', bang = true })
          else gitsigns.nav_hunk('next') end
        end, { desc = 'next change' })
        map('n', '[c', function()
          if vim.wo.diff then vim.cmd.normal({ '[c', bang = true })
          else gitsigns.nav_hunk('prev') end
        end, { desc = 'prev change' })
        map('n', 'grb', gitsigns.reset_buffer, { desc = '[G]it [R]eset [B]uffer' })
        map('n', 'grh', gitsigns.reset_hunk, { desc = '[G]it [R]eset [H]unk' })
        map('n', 'gp', gitsigns.preview_hunk, { desc = '[G]it [P]review change' })
        map('n', '<leader>gt', ':Gitsigns toggle_current_line_blame<CR>', { desc = '[G]it [T]oggle Line Blame' })
      end,
    })
  end,
}
