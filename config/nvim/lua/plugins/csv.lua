return {
  specs = {
    { src = 'https://github.com/hat0uma/csvview.nvim' },
  },
  setup = function()
    require('csvview').setup({
      parser = { comments = { '#', '//' } },
    })
  end,
  load_on = function(load)
    local cmds = { 'CsvViewEnable', 'CsvViewDisable', 'CsvViewToggle' }
    for _, cmd_name in ipairs(cmds) do
      vim.api.nvim_create_user_command(cmd_name, function(opts)
        load()
        vim.cmd(cmd_name .. (opts.args ~= '' and (' ' .. opts.args) or ''))
      end, { nargs = '*', bang = true })
    end
  end,
}
