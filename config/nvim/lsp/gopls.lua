---@type vim.lsp.Config
return {
	cmd = { "gopls" },
	root_markers = { "go.mod", ".git" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
}
