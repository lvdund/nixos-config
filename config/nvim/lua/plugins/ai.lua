return {
  'sudo-tee/opencode.nvim',
  config = function()
    require('opencode').setup {
      preferred_picker = 'fzf',
      preferred_completion = 'blink',
      default_global_keymaps = false,
      keymap_prefix = '<leader>o',
      opencode_executable = 'opencode',
      keymap = {
        editor = {
          ['<leader>oo'] = { 'toggle' }, -- Open opencode. Close if opened
          ['<leader>o/'] = { 'quick_chat', mode = { 'n', 'x' } }, -- Open quick chat input with selection context in visual mode or current line context in normal mode
          ['<leader>orr'] = { 'diff_restore_snapshot_file' }, -- Restore a file to a restore point
          ['<leader>orR'] = { 'diff_restore_snapshot_all' }, -- Restore all files to a restore point
          ['<leader>otr'] = { 'toggle_reasoning_output' }, -- Toggle reasoning output (thinking steps)
        },
        input_window = {
          ['<S-cr>'] = { 'submit_input_prompt', mode = { 'n', 'i' } }, -- Submit prompt (normal mode and insert mode)
          ['<esc>'] = { 'close' }, -- Close UI windows
          ['<C-c>'] = { 'cancel' }, -- Cancel opencode request while it is running
          ['~'] = { 'mention_file', mode = 'i' }, -- Pick a file and add to context. See File Mentions section
          ['@'] = { 'mention', mode = 'i' }, -- Insert mention (file/agent)
          ['/'] = { 'slash_commands', mode = 'i' }, -- Pick a command to run in the input window
          ['#'] = { 'context_items', mode = 'i' }, -- Manage context items (current file, selection, diagnostics, mentioned files)
          ['<M-v>'] = { 'paste_image', mode = 'i' }, -- Paste image from clipboard as attachment
          ['<up>'] = { 'prev_prompt_history', mode = { 'n', 'i' } }, -- Navigate to previous prompt in history
          ['<down>'] = { 'next_prompt_history', mode = { 'n', 'i' } }, -- Navigate to next prompt in history
          ['<M-m>'] = { 'switch_mode' }, -- Switch between modes (build/plan)
          ['<M-r>'] = { 'cycle_variant', mode = { 'n', 'i' } }, -- Cycle through available model variants
        },
        output_window = {
          ['<esc>'] = { 'close' }, -- Close UI windows
          ['<C-c>'] = { 'cancel' }, -- Cancel opencode request while it is running
          [']]'] = { 'next_message' }, -- Navigate to next message in the conversation
          ['[['] = { 'prev_message' }, -- Navigate to previous message in the conversation
          ['i'] = { 'focus_input', 'n' }, -- Focus on input window and enter insert mode at the end of the input from the output window
          ['<M-r>'] = { 'cycle_variant', mode = { 'n' } }, -- Cycle through available model variants
        },
      },
      ui = {
        position = 'right', -- 'right' (default), 'left' or 'current'. Position of the UI split. 'current' uses the current window for the output.
        input_position = 'bottom', -- 'bottom' (default) or 'top'. Position of the input window
        window_width = 0.40, -- Width as percentage of editor width
        zoom_width = 0.8, -- Zoom width as percentage of editor width
        display_model = true, -- Display model name on top winbar
        display_context_size = true, -- Display context size in the footer
        display_cost = true, -- Display cost in the footer
        window_highlight = 'Normal:OpencodeBackground,FloatBorder:OpencodeBorder', -- Highlight group for the opencode window
        icons = {
          preset = 'nerdfonts', -- 'nerdfonts' | 'text'. Choose UI icon style (default: 'nerdfonts')
          overrides = {}, -- Optional per-key overrides, see section below
        },
        output = {
          tools = {
            show_output = true, -- Show tools output [diffs, cmd output, etc.] (default: true)
            show_reasoning_output = true, -- Show reasoning/thinking steps output (default: true)
          },
          rendering = {
            markdown_debounce_ms = 250, -- Debounce time for markdown rendering on new data (default: 250ms)
            on_data_rendered = nil, -- Called when new data is rendered; set to false to disable default RenderMarkdown/Markview behavior
          },
        },
        input = {
          min_height = 0.10, -- min height of prompt input as percentage of window height
          max_height = 0.25, -- max height of prompt input as percentage of window height
          text = {
            wrap = false, -- Wraps text inside input window
          },
          -- Auto-hide input window when prompt is submitted or focus switches to output window
          auto_hide = false,
        },
        picker = {
          snacks_layout = nil, -- `layout` opts to pass to Snacks.picker.pick({ layout = ... })
        },
        completion = {
          file_sources = {
            enabled = true,
            preferred_cli_tool = 'rg', -- 'fd','fdfind','rg','git','server' if nil, it will use the best available tool, 'server' uses opencode cli to get file list (works cross platform) and supports folders
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
            max_display_length = 50, -- Maximum length for file path display in completion, truncates from left with "..."
          },
        },
      },
      context = {
        enabled = true, -- Enable automatic context capturing
        cursor_data = {
          enabled = false, -- Include cursor position and line content in the context
          context_lines = 5, -- Number of lines before and after cursor to include in context
        },
        diagnostics = {
          info = false, -- Include diagnostics info in the context (default to false
          warn = true, -- Include diagnostics warnings in the context
          error = true, -- Include diagnostics errors in the context
          only_closest = false, -- If true, only diagnostics for cursor/selection
        },
        current_file = {
          enabled = true, -- Include current file path and content in the context
          show_full_path = true,
        },
        files = {
          enabled = true,
          show_full_path = true,
        },
        selection = {
          enabled = true, -- Include selected text in the context
        },
        buffer = {
          enabled = false, -- Disable entire buffer context by default, only used in quick chat
        },
        git_diff = {
          enabled = false,
        },
      },
      debug = {
        enabled = false, -- Enable debug messages in the output window
        capture_streamed_events = false,
        show_ids = true,
        quick_chat = {
          keep_session = false, -- Keep quick_chat sessions for inspection, this can pollute your sessions list
          set_active_session = false,
        },
      },
      prompt_guard = nil, -- Optional function that returns boolean to control when prompts can be sent (see Prompt Guard section)

      -- User Hooks for custom behavior at certain events
      hooks = {
        on_file_edited = nil, -- Called after a file is edited by opencode.
        on_session_loaded = nil, -- Called after a session is loaded.
        on_done_thinking = nil, -- Called when opencode finishes thinking (all jobs complete).
        on_permission_requested = nil, -- Called when a permission request is issued.
      },
      quick_chat = {
        default_model = nil, -- works better with a fast model like gpt-4.1
        default_agent = nil, -- plan ensure no file modifications by default
        instructions = nil, -- Use built-in instructions if nil
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
      ft = { 'markdown', 'Avante', 'copilot-chat', 'opencode_output' },
    },
    'saghen/blink.cmp',
    'ibhagwan/fzf-lua',
  },
}
