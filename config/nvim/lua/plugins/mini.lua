vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

require("mini.tabline").setup({
	show_icons = true,
	format = nil,
	tabpage_section = "left",
})

require("mini.surround").setup({
	custom_surroundings = nil,
	highlight_duration = 500,
	-- Module mappings. Use `''` (empty string) to disable one.
	mappings = {
		add = "sa", -- Add surrounding in Normal and Visual modes
		delete = "sd", -- Delete surrounding
		replace = "sr", -- Replace surrounding

		find = "",
		find_left = "",
		highlight = "",
		update_n_lines = "",
	},
	n_lines = 20,
	respect_selection_type = false,
	search_method = "cover",
	silent = false,
})

require("mini.pairs").setup({
	modes = { insert = true, command = false, terminal = false },
	mappings = {
		["("] = { action = "open", pair = "()", neigh_pattern = "^[^\\]" },
		["["] = { action = "open", pair = "[]", neigh_pattern = "^[^\\]" },
		["{"] = { action = "open", pair = "{}", neigh_pattern = "^[^\\]" },
		[")"] = { action = "close", pair = "()", neigh_pattern = "^[^\\]" },
		["]"] = { action = "close", pair = "[]", neigh_pattern = "^[^\\]" },
		["}"] = { action = "close", pair = "{}", neigh_pattern = "^[^\\]" },
		['"'] = { action = "closeopen", pair = '""', neigh_pattern = "^[^\\]", register = { cr = false } },
		["'"] = { action = "closeopen", pair = "''", neigh_pattern = "^[^%a\\]", register = { cr = false } },
		["`"] = { action = "closeopen", pair = "``", neigh_pattern = "^[^\\]", register = { cr = false } },
	},
})

local miniclue = require("mini.clue")
miniclue.setup({
	triggers = {
		{ mode = { "n", "x" }, keys = "<Leader>" },
		{ mode = "n", keys = "[" },
		{ mode = "n", keys = "]" },
		{ mode = "i", keys = "<C-x>" },
		{ mode = { "n", "x" }, keys = "g" },
		{ mode = { "n", "x" }, keys = "'" },
		{ mode = { "n", "x" }, keys = "`" },
		{ mode = { "n", "x" }, keys = '"' },
		{ mode = { "i", "c" }, keys = "<C-r>" },
		{ mode = "n", keys = "<C-w>" },
		{ mode = { "n", "x" }, keys = "z" },
	},

	clues = {
		-- Enhance this by adding descriptions for <Leader> mapping groups
		miniclue.gen_clues.square_brackets(),
		miniclue.gen_clues.builtin_completion(),
		miniclue.gen_clues.g(),
		miniclue.gen_clues.marks(),
		miniclue.gen_clues.registers(),
		miniclue.gen_clues.windows(),
		miniclue.gen_clues.z(),
	},
	window = {
		delay = 100,
		scroll_down = "<C-d>",
		scroll_up = "<C-u>",
	},
})
