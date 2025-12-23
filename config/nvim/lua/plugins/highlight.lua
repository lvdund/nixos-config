return {
  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      allow_vim_regex = { 'php', 'ruby' },
    },
    config = function(_, opts)
      local parsers_loaded = {}
      local parsers_pending = {}
      local parsers_failed = {}

      local ns = vim.api.nvim_create_namespace 'treesitter.start'

      ---@param lang string
      local function start(lang)
        local ok = pcall(vim.treesitter.start, 0, lang)
        if not ok then
          return false
        end

        -- NOTE: not needed if indent actually worked for these languages without
        -- vim regex or if treesitter indent was used
        if vim.tbl_contains(opts.allow_vim_regex, vim.bo.filetype) then
          vim.bo.syntax = 'on'
        end

        vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'

        -- NOTE: indent forces a re-parse, which negates the benefit of async
        -- parsing see https://github.com/nvim-treesitter/nvim-treesitter/issues/7840
        -- vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"

        return true
      end

      -- NOTE: parsers may take long to load (big binary files) so try to start
      -- them async in the next render if not loaded yet
      vim.api.nvim_set_decoration_provider(ns, {
        on_start = vim.schedule_wrap(function()
          if #parsers_pending == 0 then
            return false
          end
          for _, data in ipairs(parsers_pending) do
            if vim.api.nvim_win_is_valid(data.winnr) and vim.api.nvim_buf_is_valid(data.bufnr) then
              vim._with({ win = data.winnr, buf = data.bufnr }, function()
                if start(data.lang) then
                  parsers_loaded[data.lang] = true
                else
                  parsers_failed[data.lang] = true
                end
              end)
            end
          end
          parsers_pending = {}
        end),
      })

      vim.api.nvim_create_autocmd('FileType', {
        callback = function(event)
          local lang = vim.treesitter.language.get_lang(event.match)
          if not lang or parsers_failed[lang] then
            return
          end

          if parsers_loaded[lang] then
            start(lang)
          else
            table.insert(parsers_pending, {
              lang = lang,
              winnr = vim.api.nvim_get_current_win(),
              bufnr = event.buf,
            })
          end
        end,
      })

      vim.api.nvim_create_user_command('TSInstallAll', function()
        require('nvim-treesitter').install(opts.ensure_install)
      end, {})
    end,
  },
  -- {
  --   'nvim-treesitter/nvim-treesitter-context',
  --   dependencies = { 'nvim-treesitter/nvim-treesitter' },
  --   config = function()
  --     require('treesitter-context').setup {
  --       enable = true, -- Enable the plugin
  --       max_lines = 3, -- Maximum number of context lines shown (0 = unlimited)
  --       trim_scope = 'outer', -- Which context lines to trim if max_lines is exceeded
  --       min_window_height = 0, -- Minimum editor window height to enable context
  --       patterns = { -- Patterns to show as context
  --         default = {
  --           'class',
  --           'function',
  --           'method',
  --           'for',
  --           'while',
  --           'if',
  --           'switch',
  --           'case',
  --           'type', -- Go, Rust, etc.
  --           'struct', -- C, C++
  --         },
  --       },
  --       zindex = 20, -- Z-index of the context window
  --       mode = 'topline', -- "cursor" = follow cursor, "topline" = follow top line
  --       separator = nil, -- You can set e.g. "─" to visually separate context
  --     }
  --   end,
  -- },
  -- {
  --   'Wansmer/symbol-usage.nvim',
  --   event = 'LspAttach',
  --   config = function()
  --     local function h(name)
  --       return vim.api.nvim_get_hl(0, { name = name })
  --     end
  --     vim.api.nvim_set_hl(0, 'SymbolUsageRounding', { fg = h('CursorLine').bg, italic = true })
  --     vim.api.nvim_set_hl(0, 'SymbolUsageContent', { bg = h('CursorLine').bg, fg = h('Comment').fg, italic = true })
  --     vim.api.nvim_set_hl(0, 'SymbolUsageRef', { fg = h('Function').fg, bg = h('CursorLine').bg, italic = true })
  --     vim.api.nvim_set_hl(0, 'SymbolUsageDef', { fg = h('Type').fg, bg = h('CursorLine').bg, italic = true })
  --     vim.api.nvim_set_hl(0, 'SymbolUsageImpl', { fg = h('@keyword').fg, bg = h('CursorLine').bg, italic = true })
  --     local function text_format(symbol)
  --       local res = {}
  --       local round_start = { '', 'SymbolUsageRounding' }
  --       local round_end = { '', 'SymbolUsageRounding' }
  --       local stacked_functions_content = symbol.stacked_count > 0 and ('+%s'):format(symbol.stacked_count) or ''
  --       if symbol.references then
  --         local usage = symbol.references <= 1 and 'usage' or 'usages'
  --         local num = symbol.references == 0 and 'no' or symbol.references
  --         table.insert(res, round_start)
  --         table.insert(res, { '󰌹 ', 'SymbolUsageRef' })
  --         table.insert(res, { ('%s %s'):format(num, usage), 'SymbolUsageContent' })
  --         table.insert(res, round_end)
  --       end
  --       if symbol.definition then
  --         if #res > 0 then
  --           table.insert(res, { ' ', 'NonText' })
  --         end
  --         table.insert(res, round_start)
  --         table.insert(res, { '󰳽 ', 'SymbolUsageDef' })
  --         table.insert(res, { symbol.definition .. ' defs', 'SymbolUsageContent' })
  --         table.insert(res, round_end)
  --       end
  --       if symbol.implementation then
  --         if #res > 0 then
  --           table.insert(res, { ' ', 'NonText' })
  --         end
  --         table.insert(res, round_start)
  --         table.insert(res, { '󰡱 ', 'SymbolUsageImpl' })
  --         table.insert(res, { symbol.implementation .. ' impls', 'SymbolUsageContent' })
  --         table.insert(res, round_end)
  --       end
  --       if stacked_functions_content ~= '' then
  --         if #res > 0 then
  --           table.insert(res, { ' ', 'NonText' })
  --         end
  --         table.insert(res, round_start)
  --         table.insert(res, { ' ', 'SymbolUsageImpl' })
  --         table.insert(res, { stacked_functions_content, 'SymbolUsageContent' })
  --         table.insert(res, round_end)
  --       end
  --       return res
  --     end
  --     require('symbol-usage').setup {
  --       text_format = text_format,
  --     }
  --   end,
  -- },
}
