---@type vim.lsp.Config
return {
  cmd = { "clangd" },
  root_markers = { ".clangd", "compile_commands.json", "compile_flags.txt", ".git" },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
}
