local external_formatters = {
	lua = { "stylua %" },
	python = { "black --quiet %" },
	nix = { "alejandra %" },
	yaml = { "yamlfmt %" },
	go = { "goimports -w %", "gofumpt -w %" },
}

local function run_external(cmd)
	local bin = cmd:match("^(%S+)")
	if vim.fn.executable(bin) ~= 1 then
		vim.notify(("[format] %s is not installed, falling back to LSP"):format(bin), vim.log.levels.WARN)
		return false
	end
	vim.cmd("silent !" .. cmd)
	return true
end

local function custom_format()
	local ft = vim.bo.filetype
	local view = vim.fn.winsaveview()
	local cmds = external_formatters[ft]

	if cmds then
		vim.cmd("silent! write")
		local ok = true
		for _, cmd in ipairs(cmds) do
			ok = run_external(cmd) and ok
		end
		if ok then
			vim.cmd("edit!")
			vim.cmd("redraw!") -- `silent !` skips the redraw
			vim.fn.winrestview(view)
			return
		end
	end

	-- json and everything else (or missing external tool): LSP
	vim.cmd("silent! write")
	vim.lsp.buf.format()
end

vim.keymap.set("n", "gf", custom_format, { noremap = true, silent = true })
