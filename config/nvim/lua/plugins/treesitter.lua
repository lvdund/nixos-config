vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })

vim.cmd("syntax off")

require("nvim-treesitter").setup({
  install_dir = vim.fn.stdpath("data") .. "/site",
})

require("nvim-treesitter").install({
  "bash",
  "dockerfile",
  "git_config",
  "git_rebase",
  "gitattributes",
  "gitcommit",
  "gitignore",
  "go",
  "gomod",
  "gosum",
  "json",
  "toml",
  "yaml",
  "lua",
  "make",
  "markdown",
  "python",
  "nix",
  "c",
  "cpp",
  "regex",
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
