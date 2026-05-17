-- Highlight same variable under cursor using LSP documentHighlight
-- Requires LSP client supporting textDocument/documentHighlight

local group = vim.api.nvim_create_augroup("highlight_cursor", { clear = true })

-- Highlight colors (moonfly-compatible subtle backgrounds)
vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "#364444" })
vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = "#3b4d4d" })
vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = "#4a3636" })

-- Debounce timer: only request highlights after cursor stops moving
local timer = vim.uv.new_timer()
local DEBOUNCE_MS = 50

local function highlight_cursor()
  timer:stop()
  vim.lsp.buf.clear_references()
  timer:start(DEBOUNCE_MS, 0, function()
    vim.schedule(vim.lsp.buf.document_highlight)
  end)
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    if not client:supports_method("textDocument/documentHighlight") then
      return
    end

    local buf_group = vim.api.nvim_create_augroup("highlight_cursor_buf_" .. ev.buf, { clear = true })

    vim.api.nvim_create_autocmd("CursorMoved", {
      group = buf_group,
      buffer = ev.buf,
      callback = highlight_cursor,
    })

    vim.api.nvim_create_autocmd("BufLeave", {
      group = buf_group,
      buffer = ev.buf,
      callback = vim.lsp.buf.clear_references,
    })
  end,
})

vim.api.nvim_create_autocmd("LspDetach", {
  group = group,
  callback = function(ev)
    vim.api.nvim_create_augroup("highlight_cursor_buf_" .. ev.buf, { clear = true })
    pcall(vim.lsp.buf.clear_references)
  end,
})
