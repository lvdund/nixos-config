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
    add = "sa",   -- Add surrounding in Normal and Visual modes
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
