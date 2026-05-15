local function jump_reference(direction)
  local params = vim.lsp.util.make_position_params(0, "utf-8")
  params.context = { includeDeclaration = true }

  vim.lsp.buf_request(0, "textDocument/references", params, function(err, result, ctx)
    if err or not result or vim.tbl_isempty(result) then
      return
    end

    local bufnr = ctx.bufnr
    local curr_win = vim.api.nvim_get_current_win()
    local cursor = vim.api.nvim_win_get_cursor(curr_win)
    local curr_line = cursor[1] - 1
    local curr_col = cursor[2]

    local refs = {}
    local curr_uri = vim.uri_from_bufnr(bufnr)
    for _, ref in ipairs(result) do
      if ref.uri == curr_uri then
        table.insert(refs, ref.range.start)
      end
    end

    table.sort(refs, function(a, b)
      if a.line ~= b.line then
        return a.line < b.line
      end
      return a.character < b.character
    end)

    if #refs == 0 then
      return
    end

    local target
    if direction == "next" then
      for _, ref in ipairs(refs) do
        if ref.line > curr_line or (ref.line == curr_line and ref.character > curr_col) then
          target = ref
          break
        end
      end
      target = target or refs[1]
    else
      for i = #refs, 1, -1 do
        local ref = refs[i]
        if ref.line < curr_line or (ref.line == curr_line and ref.character < curr_col) then
          target = ref
          break
        end
      end
      target = target or refs[#refs]
    end

    if target then
      vim.api.nvim_win_set_cursor(curr_win, { target.line + 1, target.character })
    end
  end)
end

vim.keymap.set("n", "]r", function()
  jump_reference("next")
end, { desc = "Next LSP Reference" })

vim.keymap.set("n", "[r", function()
  jump_reference("prev")
end, { desc = "Prev LSP Reference" })
