return {
  specs = {
    { src = 'https://github.com/rcarriga/nvim-notify' },
  },
  setup = function()
    require('notify').setup({
      render = 'wrapped-compact',
      stages = 'fade_in_slide_out',
      timeout = 500,
    })
  end,
}
