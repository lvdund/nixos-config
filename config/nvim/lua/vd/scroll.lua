-- scroll
local function smooth_scroll(percentage, duration_ms)
  local height = vim.api.nvim_win_get_height(0)
  local total_lines = math.floor(height * math.abs(percentage))
  if total_lines == 0 then return end

  -- Calculate delay between each line to match the total duration
  local delay = math.floor(duration_ms / total_lines)
  local key = percentage > 0 and [[<C-e>]] or [[<C-y>]]
  local scroll_cmd = vim.api.nvim_replace_termcodes(key, true, false, true)
  
  -- Use Neovim's event loop timer
  local timer = vim.uv.new_timer()
  local count = 0
  
  timer:start(0, delay, vim.schedule_wrap(function()
    if count < total_lines then
      vim.api.nvim_feedkeys(scroll_cmd, 'n', true)
      count = count + 1
    else
      timer:stop()
      timer:close()
    end
  end))
end

-- Map to all modes
local modes = { 'n', 'v', 'x', 'i' }
for _, mode in ipairs(modes) do
  vim.keymap.set(mode, '<PageDown>', function()
    smooth_scroll(0.2, 70)
  end, { desc = "Smooth scroll down" })

  -- PageUp: Scroll up 20% over 70ms
  vim.keymap.set(mode, '<PageUp>', function()
    smooth_scroll(-0.2, 70)
  end, { desc = "Smooth scroll up" })
end
