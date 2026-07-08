vim.pack.add({ "https://github.com/romus204/tree-sitter-manager.nvim" })

vim.cmd("syntax off")

require("tree-sitter-manager").setup({
  ensure_installed = {
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
  },
  border = "single",
  highlight = true,
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local filetype = args.match
    local lang = vim.treesitter.language.get_lang(filetype)
    if vim.treesitter.language.add(lang) then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.treesitter.start()
    end
  end,
})
