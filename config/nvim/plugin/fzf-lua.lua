vim.pack.add({
  "https://github.com/ibhagwan/fzf-lua",
})

local actions = require("fzf-lua.actions")
local fzf = require("fzf-lua")
fzf.setup({
  keymap = {
    builtin = {
      ["<C-d>"] = "preview-page-down",
      ["<C-u>"] = "preview-page-up",
    },
    fzf = {
      true,
      ["ctrl-q"] = "select-all+accept",
    },
  },
  winopts = {
    height = 0.95,
    width = 0.90,
    preview = {
      layout = "vertical",
      vertical = "down:30%",
    },
  },
  actions = {
    files = {
      ["default"] = actions.file_edit,
      ["ctrl-s"] = actions.file_split,
      ["ctrl-v"] = actions.file_vsplit,
      ["alt-q"] = actions.file_sel_to_qf,
    },
  },
  files = {
    formatter = "path.filename_first",
  },
  grep = {
    rg_glob = true,
    rg_opts = "--sort-files --hidden --column --line-number --no-heading --color=always --smart-case -g '!{.git,node_modules,.venv}/*'",
    glob_flag = "--iglob",
    glob_separator = "%s%-%-",
  },
})

fzf.register_ui_select(function(_, items)
  local min_h, max_h = 0.15, 0.70
  local h = (#items + 4) / vim.o.lines
  if h < min_h then
    h = min_h
  elseif h > max_h then
    h = max_h
  end
  return { winopts = { height = h, width = 0.60, row = 0.40 } }
end)

vim.keymap.set("n", "sf", "<cmd>FzfLua files<cr>", { desc = "Find files" })
vim.keymap.set("n", "sg", "<cmd>FzfLua live_grep<cr>", { desc = "Find live grep" })
vim.keymap.set("n", "ss", "<cmd>FzfLua resume<cr>", { desc = "Resume last picker" })
vim.keymap.set("n", "sb", "<cmd>FzfLua buffers<cr>", { desc = "Buffers" })

vim.keymap.set("n", "sd", fzf.diagnostics_document, { desc = "References" })
vim.keymap.set("n", "sD", fzf.diagnostics_workspace, { desc = "References" })
vim.keymap.set("n", "grr", fzf.lsp_references, { desc = "References" })
vim.keymap.set("n", "gri", fzf.lsp_implementations, { desc = "Implementations" })
vim.keymap.set("n", "gra", fzf.lsp_code_actions, { desc = "Code actions" })
vim.keymap.set("n", "gd", fzf.lsp_definitions, { desc = "Code actions" })
vim.keymap.set("n", "grt", fzf.lsp_typedefs, { desc = "Code actions" })

vim.keymap.set('n', 'grn', vim.lsp.buf.rename, { desc = 'LSP rename' })
vim.keymap.set('n', 'gf', function() vim.lsp.buf.format { async = true } end)

vim.keymap.set("n", "gs", fzf.git_status, { desc = "Code actions" })
