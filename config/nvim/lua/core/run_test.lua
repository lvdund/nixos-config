local M = {}

local QUERY_TESTS = vim.treesitter.query.parse(
	"go",
	[[
(function_declaration
  name: (identifier) @name
  (#match? @name "^Test"))
]]
)

local function get_tests(bufnr)
	local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "go")
	if not ok or not parser then
		vim.notify("run_test: no Treesitter parser for go (run :TSInstall go)", vim.log.levels.ERROR)
		return {}
	end

	local tree = parser:parse()[1]
	if not tree then
		return {}
	end

	local root = tree:root()
	local out = {}

	for _, node in QUERY_TESTS:iter_captures(root, bufnr, 0, -1) do
		local name = vim.treesitter.get_node_text(node, bufnr)
		local sr, _, er, _ = node:parent():range()
		table.insert(out, { name = name, start_row = sr, end_row = er })
	end

	table.sort(out, function(a, b)
		return a.start_row < b.start_row
	end)

	return out
end

local function test_at_cursor(cursor_row, tests)
	for _, t in ipairs(tests) do
		if cursor_row >= t.start_row and cursor_row <= t.end_row then
			return t.name
		end
	end
end

local function nearest_test(cursor_row, tests)
	local best, dist
	for _, t in ipairs(tests) do
		local d = math.abs(cursor_row - t.start_row)
		if not dist or d < dist then
			dist = d
			best = t.name
		end
	end
	return best
end

local function open_terminal(cmd, mode)
	-- Run via shell and keep terminal open after test finishes
	local shell_cmd = string.format("%s -lc %s", vim.o.shell, vim.fn.shellescape(cmd .. "; exec " .. vim.o.shell))

	if mode == "current" then
		vim.cmd("terminal " .. shell_cmd)
	else
		vim.cmd("split | terminal " .. shell_cmd)
	end
	vim.cmd("startinsert")
end

---@param opts? { mode?: 'current'|'buffer' }
function M.run(opts)
	opts = opts or {}
	local mode = opts.mode or "buffer"

	local bufnr = vim.api.nvim_get_current_buf()

	if vim.bo[bufnr].filetype ~= "go" then
		vim.notify("run_test: not a Go file", vim.log.levels.WARN)
		return
	end

	local tests = get_tests(bufnr)
	if #tests == 0 then
		vim.notify("run_test: no Test* function found", vim.log.levels.WARN)
		return
	end

	local row = vim.api.nvim_win_get_cursor(0)[1] - 1
	local name = test_at_cursor(row, tests) or nearest_test(row, tests)

	local file = vim.api.nvim_buf_get_name(bufnr)
	local dir = vim.fn.fnamemodify(file, ":h")
	local cmd = string.format("cd %s && go test -v -run '^%s$' .", vim.fn.shellescape(dir), name)

	vim.notify("run_test: running " .. name, vim.log.levels.INFO)
	open_terminal(cmd, mode)
end

function M.run_current()
	M.run({ mode = "current" })
end

function M.run_new_buffer()
	M.run({ mode = "buffer" })
end

return M
