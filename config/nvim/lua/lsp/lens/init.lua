-- LSP Lens - displays reference/definition/implementation counts above functions/methods
-- Based on https://github.com/VidocqH/lsp-lens.nvim

local M = {}

local SymbolKind = vim.lsp.protocol.SymbolKind

-- Default configuration
local config = {
  enable = true,
  include_declaration = false,
  hide_zero_counts = true,
  separator = " | ",
  sections = {
    definition = function(count)
      return "Definitions: " .. count
    end,
    references = function(count)
      return "References: " .. count
    end,
    implements = function(count)
      return "Implements: " .. count
    end,
    git_authors = function(latest_author, count)
      return " " .. latest_author .. (count - 1 == 0 and "" or (" + " .. count - 1))
    end,
  },
  decorator = function(line)
    return line
  end,
  ignore_filetype = { "prisma", "neo-tree" },
  target_symbol_kinds = { SymbolKind.Function, SymbolKind.Method, SymbolKind.Interface },
  wrapper_symbol_kinds = { SymbolKind.Class, SymbolKind.Struct },
}

local ns_id = vim.api.nvim_create_namespace("lsp-lens")
local requesting_buffers = {}

-- Get LSP clients (compatible with 0.9 and 0.10+)
local function get_clients(bufnr)
  if vim.lsp.get_clients then
    return vim.lsp.get_clients({ bufnr = bufnr })
  end
  return vim.lsp.get_active_clients({ bufnr = bufnr })
end

-- Check if buffer is currently requesting
local function is_requesting(bufnr)
  return vim.tbl_contains(requesting_buffers, bufnr)
end

-- Add/remove buffer from requesting list
local function set_requesting(bufnr, is_start)
  if is_start then
    if not is_requesting(bufnr) then
      table.insert(requesting_buffers, bufnr)
    end
  else
    requesting_buffers = vim.tbl_filter(function(b)
      return b ~= bufnr
    end, requesting_buffers)
  end
end

-- Count results from LSP response
local function count_results(results)
  local count = 0
  for _, res in pairs(results or {}) do
    for _ in pairs(res.result or {}) do
      count = count + 1
    end
  end
  return count
end

-- Extract functions/methods from document symbols (recursive)
local function extract_from_symbols(symbols, functions)
  functions = functions or {}
  for _, symbol in pairs(symbols or {}) do
    if vim.tbl_contains(config.target_symbol_kinds, symbol.kind) then
      if symbol.range and symbol.range.start then
        table.insert(functions, {
          name = symbol.name,
          range_start = symbol.range.start,
          range_end = symbol.range["end"],
          selection_start = symbol.selectionRange.start,
          selection_end = symbol.selectionRange["end"],
        })
      end
    end
    -- Recursively search in wrapper symbols (classes, structs)
    if vim.tbl_contains(config.wrapper_symbol_kinds, symbol.kind) then
      extract_from_symbols(symbol.children, functions)
    end
  end
  return functions
end

-- Extract functions from buf_request_all response
local function get_functions(doc_symbols_response)
  local functions = {}
  for _, res in pairs(doc_symbols_response or {}) do
    if res.result then
      extract_from_symbols(res.result, functions)
    end
  end
  return functions
end

-- Check if any LSP client supports a method
local function lsp_supports_method(bufnr, method)
  for _, client in pairs(get_clients(bufnr)) do
    if client.supports_method(method) then
      return true
    end
  end
  return false
end

-- Clear existing virtual lines
local function clear_lens(bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
end

-- Build display string from counting results
local function build_display_string(counting)
  local text = ""

  local function append_with(count, formatter)
    if formatter == nil or (config.hide_zero_counts and count == 0) then
      return
    end
    local formatted = formatter(count)
    if formatted == nil or formatted == "" then
      return
    end
    text = text == "" and formatted or text .. config.separator .. formatted
  end

  if counting.references then
    append_with(counting.references, config.sections.references)
  end

  if counting.definition then
    append_with(counting.definition, config.sections.definition)
  end

  if counting.implementation then
    append_with(counting.implementation, config.sections.implements)
  end

  if counting.git_authors then
    local ga = counting.git_authors
    if config.sections.git_authors and not (config.hide_zero_counts and ga.count == 0) then
      local formatted = config.sections.git_authors(ga.latest_author, ga.count)
      if formatted and formatted ~= "" then
        text = text == "" and formatted or text .. config.separator .. formatted
      end
    end
  end

  return text == "" and "" or config.decorator(text)
end

-- Get git authors for a line range using git blame
local function get_git_authors(bufnr, start_row, end_row, callback)
  local file_path = vim.fn.expand("#" .. bufnr .. ":p")
  if file_path == "" then
    callback(nil, 0)
    return
  end

  local authors = {}
  local most_recent_author = nil

  vim.system({ "git", "blame", "-L", start_row .. "," .. end_row, "--incremental", file_path }, {
    text = true,
  }, function(result)
    if result.code ~= 0 then
      callback(nil, 0)
      return
    end

    for line in result.stdout:gmatch("[^\r\n]+") do
      local space_pos = line:find(" ")
      if space_pos then
        local key = line:sub(1, space_pos - 1)
        local val = line:sub(space_pos + 1)
        if key == "author" then
          authors[val] = true
          if most_recent_author == nil then
            most_recent_author = val
          end
        end
      end
    end

    local author_count = 0
    for _ in pairs(authors) do
      author_count = author_count + 1
    end

    callback(most_recent_author, author_count)
  end)
end

-- Display lens above functions
local function display_lens(bufnr, results)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  clear_lens(bufnr)

  for _, item in pairs(results or {}) do
    local display_str = build_display_string(item.counting)
    if display_str ~= "" then
      local text = string.rep(" ", item.range_start.character) .. display_str
      local line = item.range_start.line

      if line >= 0 and line < vim.api.nvim_buf_line_count(bufnr) then
        vim.api.nvim_buf_set_extmark(bufnr, ns_id, line, 0, {
          virt_lines = { { { text, "LspLens" } } },
          virt_lines_above = true,
        })
      end
    end
  end
end

-- Check if all requests for a function are complete
local function all_requests_done(finished)
  for _, f in pairs(finished) do
    if not (f.references and f.definition and f.implementation and f.git_authors) then
      return false
    end
  end
  return true
end

-- Main procedure
local function procedure()
  if not config.enable then
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()

  -- Skip ignored filetypes
  if vim.tbl_contains(config.ignore_filetype, vim.bo[bufnr].filetype) then
    return
  end

  -- Prevent duplicate requests
  if is_requesting(bufnr) then
    return
  end

  -- Check for LSP support
  if not lsp_supports_method(bufnr, "textDocument/documentSymbol") then
    return
  end

  set_requesting(bufnr, true)

  local params = { textDocument = vim.lsp.util.make_text_document_params() }

  vim.lsp.buf_request_all(bufnr, "textDocument/documentSymbol", params, function(doc_symbols)
    local functions = get_functions(doc_symbols)
    local results = {}
    local finished = {}

    if #functions == 0 then
      set_requesting(bufnr, false)
      return
    end

    -- Initialize results and finished trackers
    for idx, fn in ipairs(functions) do
      results[idx] = {
        range_start = fn.range_start,
        counting = {},
      }
      finished[idx] = { references = false, definition = false, implementation = false, git_authors = false }

      -- Build query params for this function
      local query_params = {
        textDocument = vim.lsp.util.make_text_document_params(),
        position = {
          character = fn.selection_end.character,
          line = fn.selection_end.line,
        },
      }

      -- Request references
      if config.sections.references and lsp_supports_method(bufnr, "textDocument/references") then
        local ref_params = vim.deepcopy(query_params)
        ref_params.context = { includeDeclaration = config.include_declaration }
        vim.lsp.buf_request_all(bufnr, "textDocument/references", ref_params, function(refs)
          results[idx].counting.references = count_results(refs)
          finished[idx].references = true
        end)
      else
        finished[idx].references = true
      end

      -- Request definitions
      if config.sections.definition and lsp_supports_method(bufnr, "textDocument/definition") then
        vim.lsp.buf_request_all(bufnr, "textDocument/definition", query_params, function(defs)
          results[idx].counting.definition = count_results(defs)
          finished[idx].definition = true
        end)
      else
        finished[idx].definition = true
      end

      -- Request implementations
      if config.sections.implements and lsp_supports_method(bufnr, "textDocument/implementation") then
        vim.lsp.buf_request_all(bufnr, "textDocument/implementation", query_params, function(imps)
          results[idx].counting.implementation = count_results(imps)
          finished[idx].implementation = true
        end)
      else
        finished[idx].implementation = true
      end

      -- Request git authors
      if config.sections.git_authors then
        get_git_authors(bufnr, fn.range_start.line + 1, fn.range_end.line + 1, function(latest_author, count)
          results[idx].counting.git_authors = { latest_author = latest_author, count = count }
          finished[idx].git_authors = true
        end)
      else
        finished[idx].git_authors = true
      end
    end

    -- Poll for completion
    local timer = vim.uv.new_timer()
    timer:start(0, 100, vim.schedule_wrap(function()
      if all_requests_done(finished) then
        timer:stop()
        timer:close()
        display_lens(bufnr, results)
        set_requesting(bufnr, false)
      end
    end))
  end)
end

-- Turn lens on
local function lens_on()
  config.enable = true
  procedure()
end

-- Turn lens off
local function lens_off()
  config.enable = false
  clear_lens(0)
end

-- Toggle lens
local function lens_toggle()
  if config.enable then
    lens_off()
  else
    lens_on()
  end
end

function M.setup(opts)
  -- Merge user options with defaults
  opts = opts or {}
  -- Handle boolean section options (true means use default)
  if opts.sections then
    for k, v in pairs(opts.sections) do
      if type(v) == "boolean" and v then
        opts.sections[k] = nil
      end
    end
  end
  config = vim.tbl_deep_extend("force", config, opts)

  -- Set up highlight group
  vim.api.nvim_set_hl(0, "LspLens", { link = "Comment", default = true })

  -- Commands
  vim.api.nvim_create_user_command("LspLensOn", lens_on, {})
  vim.api.nvim_create_user_command("LspLensOff", lens_off, {})
  vim.api.nvim_create_user_command("LspLensToggle", lens_toggle, {})

  -- Autocmds
  local group = vim.api.nvim_create_augroup("lsp_lens", { clear = true })
  vim.api.nvim_create_autocmd({ "LspAttach", "TextChanged", "BufEnter" }, {
    group = group,
    callback = procedure,
  })
end

return M
