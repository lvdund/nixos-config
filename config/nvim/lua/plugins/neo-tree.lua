return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', '<Cmd>Neotree position=float reveal_force_cwd<CR>', desc = 'Neotree toggle', silent = true },
    { '<C-\\>', '<Cmd>Neotree position=left reveal_force_cwd<CR>', desc = 'Neotree', silent = true },
  },
  opts = {
    default_component_configs = {
      container = {
        enable_character_fade = true,
      },
      git_status = {
        symbols = {
          -- Change type
          added = '󰷬 ',
          modified = '󰲶 ',
          deleted = '󰷩 ',
          renamed = '󰁕',
          -- Status type
          untracked = '',
          ignored = ' ',
          unstaged = '✗',
          staged = ' ',
          conflict = ' ',
        },
      },
    },
    source_selector = {
      lualine = false,
    },
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false,
        hide_by_name = {},
        hide_by_pattern = {},
        always_show = { '.gitignored' },
        always_show_by_pattern = { '.env*' },
      },
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
      bind_to_cwd = true,
      cwd_target = {
        sidebar = 'global',
        current = 'global',
      },
    },
    commands = {
      -- -- Override delete to use trash instead of rm
      -- delete = function(state)
      --   local inputs = require 'neo-tree.ui.inputs'
      --   local path = state.tree:get_node().path
      --   local msg = 'Are you sure you want to trash ' .. path
      --   inputs.confirm(msg, function(confirmed)
      --     if not confirmed then
      --       return
      --     end
      --
      --     vim.fn.system { 'trash', vim.fn.fnameescape(path) }
      --     require('neo-tree.sources.manager').refresh(state.name)
      --   end)
      -- end,
    },
  },
  -- Set up autocommand to change to project root
  config = function(_, opts)
    -- Function to find git root
    local function get_git_root()
      local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
      if vim.v.shell_error == 0 and git_root then
        return git_root
      end
      return nil
    end

    -- Auto change to git root when opening files
    vim.api.nvim_create_autocmd('BufEnter', {
      group = vim.api.nvim_create_augroup('NeoTreeGitRoot', { clear = true }),
      pattern = '*',
      callback = function()
        -- Skip if neo-tree buffer
        if vim.bo.filetype == 'neo-tree' then
          return
        end

        local git_root = get_git_root()
        if git_root and vim.fn.getcwd() ~= git_root then
          vim.cmd('cd ' .. git_root)
        end
      end,
    })

    require('neo-tree').setup(opts)
  end,
}
