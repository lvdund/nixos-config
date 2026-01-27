return {
  'ibhagwan/fzf-lua',
  event = 'VeryLazy',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    {
      '<leader>sf',
      function()
        require('fzf-lua').files()
      end,
      desc = '[S]earch [F]iles',
    },
    {
      '<leader>sg',
      function()
        require('fzf-lua').live_grep()
      end,
      desc = '[S]earch by [G]rep',
    },
    {
      '<leader>sD',
      function()
        require('fzf-lua').diagnostics_workspace()
      end,
      desc = '[S]earch [D]iagnostics',
    },
    {
      '<leader>sd',
      function()
        require('fzf-lua').diagnostics_document()
      end,
      desc = '[S]earch [D]iagnostics Buffer only',
    },
    {
      '<leader>sn',
      ':Noice fzf<CR>',
      desc = '[S]earch [N]otify',
    },
    {
      '<leader>ss',
      function()
        require('fzf-lua').resume()
      end,
      desc = '[S]earch Resume',
    },
    {
      'sb',
      function()
        require('fzf-lua').buffers()
      end,
      desc = '[S]earch [B]uffers',
    },
    {
      '<leader>gs',
      function()
        require('fzf-lua').git_status()
      end,
      desc = '[G]it [S]tatus',
    },

    -- LSP keymaps
    {
      'gra',
      function()
        require('fzf-lua').lsp_code_actions { async = false }
      end,
      desc = '[G]oto Code [A]ction',
    },
    {
      'grr',
      function()
        require('fzf-lua').lsp_references { ignore_current_line = true }
      end,
      desc = '[G]oto [R]eferences',
    },
    {
      'gri',
      function()
        require('fzf-lua').lsp_implementations()
      end,
      desc = '[G]oto [I]mplementation',
    },
    {
      'gd',
      function()
        require('fzf-lua').lsp_definitions { jump1 = true }
      end,
      desc = '[G]oto [D]efinition',
    },
    {
      'gro',
      function()
        require('fzf-lua').lsp_document_symbols()
      end,
      desc = 'Open Document Symbols',
    },
    {
      'gr0',
      function()
        require('fzf-lua').lsp_live_workspace_symbols()
      end,
      desc = 'Open Workspace Symbols',
    },
    {
      'grt',
      function()
        require('fzf-lua').lsp_typedefs()
      end,
      desc = '[G]oto [T]ype Definition',
    },
  },

  config = function()
    local actions = require 'fzf-lua.actions'
    require('fzf-lua').setup {
      keymap = {
        fzf = {
          true,
          ['ctrl-q'] = 'select-all+accept',
        },
      },
      actions = {
        files = {
          ['default'] = actions.file_edit,
          ['ctrl-s'] = actions.file_split,
          ['ctrl-v'] = actions.file_vsplit,
          ['alt-q'] = actions.file_sel_to_qf,
        },
      },
      grep = {
        rg_glob = true,
        rg_opts = "--sort-files --hidden --column --line-number --no-heading --color=always --smart-case -g '!{.git,node_modules,.venv}/*'",
        glob_flag = '--iglob',
        glob_separator = '%s%-%-',
      },
    }

    require('fzf-lua').register_ui_select(function(_, items)
      local min_h, max_h = 0.15, 0.70
      local h = (#items + 4) / vim.o.lines
      if h < min_h then
        h = min_h
      elseif h > max_h then
        h = max_h
      end
      return { winopts = { height = h, width = 0.60, row = 0.40 } }
    end)
  end,
}
