local function custom_format()
  local ft = vim.bo.filetype
  local view = vim.fn.winsaveview()
  local use_external = true

  if ft == "lua" then
    vim.cmd("silent! write")
    vim.cmd("silent !stylua %")
  elseif ft == "python" then
    vim.cmd("silent! write")
    vim.cmd("silent !black --quiet %")
  elseif ft == "go" then
    vim.cmd("silent! write")
    vim.cmd("silent !goimports -w %")
    vim.cmd("silent !gofumpt -w %")
  else
    use_external = false
    vim.lsp.buf.format()
  end

  if use_external then
    vim.cmd("edit!")
    vim.fn.winrestview(view)
  end
end

vim.keymap.set("n", "gf", custom_format, { desc = "[F]ormat" })
