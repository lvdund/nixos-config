return {
  specs = {
    { src = 'https://github.com/ibhagwan/fzf-lua' },
  },
  setup = function()
    local actions = require('fzf-lua.actions')
    require('fzf-lua').setup({
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
    })

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
  load_on = function(load)
    local function with_load(fn)
      return function()
        load()
        fn()
      end
    end

    vim.keymap.set('n', 'sf', with_load(function()
      require('fzf-lua').files()
    end), { desc = '[S]earch [F]iles' })

    vim.keymap.set('n', 'sg', with_load(function()
      require('fzf-lua').live_grep()
    end), { desc = '[S]earch by [G]rep' })

    vim.keymap.set('n', '<leader>sD', with_load(function()
      require('fzf-lua').diagnostics_workspace()
    end), { desc = '[S]earch [D]iagnostics' })

    vim.keymap.set('n', '<leader>sd', with_load(function()
      require('fzf-lua').diagnostics_document()
    end), { desc = '[S]earch [D]iagnostics Buffer only' })

    vim.keymap.set('n', 'sn', with_load(function()
      vim.cmd('Noice fzf')
    end), { desc = '[S]earch [N]otify' })

    vim.keymap.set('n', 'ss', with_load(function()
      require('fzf-lua').resume()
    end), { desc = '[S]earch Resume' })

    vim.keymap.set('n', 'sb', with_load(function()
      require('fzf-lua').buffers()
    end), { desc = '[S]earch [B]uffers' })

    vim.keymap.set('n', 'gs', with_load(function()
      require('fzf-lua').git_status()
    end), { desc = '[G]it [S]tatus' })

    vim.keymap.set('n', 'gra', with_load(function()
      require('fzf-lua').lsp_code_actions({ async = false })
    end), { desc = '[G]oto Code [A]ction' })

    vim.keymap.set('n', 'grr', with_load(function()
      require('fzf-lua').lsp_references({ ignore_current_line = true })
    end), { desc = '[G]oto [R]eferences' })

    vim.keymap.set('n', 'gri', with_load(function()
      require('fzf-lua').lsp_implementations()
    end), { desc = '[G]oto [I]mplementation' })

    vim.keymap.set('n', 'gd', with_load(function()
      require('fzf-lua').lsp_definitions({ jump1 = true })
    end), { desc = '[G]oto [D]efinition' })

    vim.keymap.set('n', 'gro', with_load(function()
      require('fzf-lua').lsp_document_symbols()
    end), { desc = 'Open Document Symbols' })

    vim.keymap.set('n', 'gr0', with_load(function()
      require('fzf-lua').lsp_live_workspace_symbols()
    end), { desc = 'Open Workspace Symbols' })

    vim.keymap.set('n', 'grt', with_load(function()
      require('fzf-lua').lsp_typedefs()
    end), { desc = '[G]oto [T]ype Definition' })
  end,
}
