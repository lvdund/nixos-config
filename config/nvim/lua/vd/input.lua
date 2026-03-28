vim.opt.keymap = ""

vim.keymap.set('i', '<M-k>', function()
  if vim.opt.keymap:get() == "" then
    vim.opt.keymap = "vietnamese-telex_utf-8"
    print("Keymap: Vietnamese Telex")
  else
    vim.opt.keymap = ""
    print("Keymap: English")
  end
end, { desc = "Toggle Vietnamese/English keymap" })



