vim.o.relativenumber = true
vim.o.number = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.confirm = true
vim.o.signcolumn = "yes"
vim.o.ttimeoutlen = 1
vim.o.scrolloff = 3

vim.opt.colorcolumn = "80"
vim.opt.textwidth = 80

vim.opt.wildignore:append("**/node_modules/*")
vim.opt.wildignore:append("**/package-lock.json")
vim.opt.fillchars:append({ eob = " " })

vim.schedule(function()
  vim.o.clipboard = "unnamedplus"
end)

require("vim._core.ui2").enable({
	enable = true,
	msg = {
		targets = {
			[""] = "msg",
			empty = "cmd",
			bufwrite = "msg",
			confirm = "cmd",
			emsg = "pager",
			echo = "msg",
			echomsg = "msg",
			echoerr = "pager",
			completion = "cmd",
			list_cmd = "pager",
			lua_error = "pager",
			lua_print = "msg",
			progress = "pager",
			rpc_error = "pager",
			quickfix = "msg",
			search_cmd = "cmd",
			search_count = "cmd",
			shell_cmd = "pager",
			shell_err = "pager",
			shell_out = "pager",
			shell_ret = "msg",
			undo = "msg",
			verbose = "pager",
			wildlist = "cmd",
			wmsg = "msg",
			typed_cmd = "cmd",
		},
		cmd = {
			height = 0.5,
		},
		dialog = {
			height = 0.5,
		},
		msg = {
			height = 0.3,
			timeout = 5000,
		},
		pager = {
			height = 0.5,
		},
	},
})

vim.diagnostic.config({
  severity_sort = true,
  update_in_insert = false,
  float = { source = "if_many" },
})
