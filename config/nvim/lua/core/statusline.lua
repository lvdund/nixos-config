local function filepath()
	local fpath = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.:h")

	if fpath == "" or fpath == "." then
		return "%<%t"
	end

	return string.format("%%<%s/%%t", fpath)
end

local function git()
	local git_info = vim.b.gitsigns_status_dict
	if not git_info or git_info.head == "" then
		return ""
	end

	local head = git_info.head
	local added = git_info.added and (" +" .. git_info.added) or ""
	local changed = git_info.changed and (" ~" .. git_info.changed) or ""
	local removed = git_info.removed and (" -" .. git_info.removed) or ""
	if git_info.added == 0 then
		added = ""
	end
	if git_info.changed == 0 then
		changed = ""
	end
	if git_info.removed == 0 then
		removed = ""
	end

	return table.concat({
		"[",
		"%#MoonflyWhite#",
		head,
		"%#GitSignsAdd#",
		added,
		"%#GitSignsChange#",
		changed,
		"%#GitSignsDelete#",
		removed,
		"%#MoonflyWhite#",
		"]",
	})
end

local function diagnostics()
	local diagnostics_lualine = vim.diagnostic.get(0)
	if not diagnostics_lualine or #diagnostics_lualine == 0 then
		return ""
	end
	local counts = {
		[vim.diagnostic.severity.ERROR] = 0,
		[vim.diagnostic.severity.WARN] = 0,
		[vim.diagnostic.severity.INFO] = 0,
		[vim.diagnostic.severity.HINT] = 0,
	}
	for _, diagnostic in ipairs(diagnostics_lualine) do
		if counts[diagnostic.severity] ~= nil then
			counts[diagnostic.severity] = counts[diagnostic.severity] + 1
		end
	end
	local parts = {}
	if counts[vim.diagnostic.severity.ERROR] > 0 then
		table.insert(parts, "%#DiagnosticError#E:" .. counts[vim.diagnostic.severity.ERROR])
	end
	if counts[vim.diagnostic.severity.WARN] > 0 then
		table.insert(parts, "%#DiagnosticWarn#W:" .. counts[vim.diagnostic.severity.WARN])
	end
	if counts[vim.diagnostic.severity.INFO] > 0 then
		table.insert(parts, "%#DiagnosticInfo#I:" .. counts[vim.diagnostic.severity.INFO])
	end
	if counts[vim.diagnostic.severity.HINT] > 0 then
		table.insert(parts, "%#DiagnosticHint#H:" .. counts[vim.diagnostic.severity.HINT])
	end
	if #parts == 0 then
		return ""
	end
	return table.concat(parts, "  ") .. "%*"
end

Statusline = {}

function Statusline.active()
	return table.concat({
		git(),
		" ",
		filepath(),
		"%=",
		diagnostics(),
		" ",
		"%y [%P %l:%c]",
	})
end

function Statusline.inactive()
	return filepath()
end

function Statusline.eval()
	if vim.g.statusline_winid == vim.api.nvim_get_current_win() then
		return Statusline.active()
	end
	return Statusline.inactive()
end

vim.o.statusline = "%!v:lua.Statusline.eval()"
