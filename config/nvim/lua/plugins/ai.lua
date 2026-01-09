return {
  'sudo-tee/opencode.nvim',
  config = function()
    require('opencode').setup {
      preferred_picker = 'telescope',
      preferred_completion = 'blink',
      default_global_keymaps = false,
      default_mode = 'build',
      keymap_prefix = '<leader>o',
      keymap = {
        editor = {
          ['<leader>oo'] = { 'toggle' },
          ['<leader>os'] = { 'select_session' },
          ['<leader>orB'] = { 'diff_revert_all_last_prompt' },
          ['<leader>orb'] = { 'diff_revert_this_last_prompt' },
          ['<leader>opa'] = { 'permission_accept' },
          ['<leader>opA'] = { 'permission_accept_all' },
          ['<leader>opd'] = { 'permission_deny' },
          ['<leader>ol'] = { 'quick_chat', mode = { 'n', 'x' } },
        },
        inline = {
          ['<leader>oi'] = { 'ask' },
        },
        input_window = {
          ['<cr>'] = { 'submit_input_prompt', mode = { 'n' } },
          ['<esc>'] = { 'close' },
          ['<C-c>'] = { 'cancel' },
          ['~'] = { 'mention_file', mode = 'i' },
          ['@'] = { 'mention', mode = 'i' },
          ['/'] = { 'slash_commands', mode = 'i' },
          ['#'] = { 'context_items', mode = 'i' },
          ['<M-v>'] = { 'paste_image', mode = 'i' },
          ['<up>'] = { 'prev_prompt_history', mode = { 'n', 'i' } },
          ['<down>'] = { 'next_prompt_history', mode = { 'n', 'i' } },
          ['k'] = { 'prev_prompt_history', mode = { 'n' } },
          ['j'] = { 'next_prompt_history', mode = { 'n' } },
        },
        output_window = {
          ['<esc>'] = { 'close' },
          ['<C-c>'] = { 'cancel' },
          [']]'] = { 'next_message' },
          ['[['] = { 'prev_message' },
          ['i'] = { 'focus_input', 'n' },
        },
        permission = {
          accept = 'a',
          accept_all = 'A',
          deny = 'd',
        },
        session_picker = {
          delete_session = { '<C-D>' },
          new_session = { '<C-N>' },
        },
        timeline_picker = {
          undo = { '<C-u>', mode = { 'i', 'n' } },
          fork = { '<C-f>', mode = { 'i', 'n' } },
        },
        history_picker = {
          delete_entry = { '<C-D>', mode = { 'i', 'n' } },
          clear_all = { '<C-X>', mode = { 'i', 'n' } },
        },
      },
      ui = {
        position = 'right',
        input_position = 'bottom',
        window_width = 0.40,
        zoom_width = 0.8,
        input_height = 0.15,
        display_model = true,
        display_context_size = true,
        display_cost = true,
        window_highlight = 'Normal:OpencodeBackground,FloatBorder:OpencodeBorder',
        icons = {
          preset = 'nerdfonts',
        },
        output = {
          tools = {
            show_output = true,
            show_reasoning_output = true,
          },
          rendering = {
            markdown_debounce_ms = 250,
            on_data_rendered = nil,
          },
        },
        input = {
          text = {
            wrap = true,
          },
        },
        completion = {
          file_sources = {
            enabled = true,
            preferred_cli_tool = 'server',
            ignore_patterns = {
              '^%.git/',
              '^%.svn/',
              '^%.hg/',
              'node_modules/',
              '%.pyc$',
              '%.o$',
              '%.obj$',
              '%.exe$',
              '%.dll$',
              '%.so$',
              '%.dylib$',
              '%.class$',
              '%.jar$',
              '%.war$',
              '%.ear$',
              'target/',
              'build/',
              'dist/',
              'out/',
              'deps/',
              '%.tmp$',
              '%.temp$',
              '%.log$',
              '%.cache$',
            },
            max_files = 10,
            max_display_length = 50,
          },
        },
      },
      context = {
        enabled = true,
        cursor_data = {
          enabled = false,
        },
        diagnostics = {
          info = false,
          warn = true,
          error = true,
        },
        current_file = {
          enabled = true,
        },
        selection = {
          enabled = true,
        },
      },
      debug = {
        enabled = false,
      },
      prompt_guard = nil,

      hooks = {
        on_file_edited = nil,
        on_session_loaded = nil,
        on_done_thinking = nil,
        on_permission_requested = nil,
      },
    }
  end,
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        anti_conceal = { enabled = false },
        file_types = { 'markdown', 'opencode_output' },
      },
      ft = { 'markdown', 'opencode_output' },
    },
    'saghen/blink.cmp',
    'nvim-telescope/telescope.nvim',
  },
}
