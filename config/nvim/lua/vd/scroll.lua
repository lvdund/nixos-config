-- Store the timer outside the function to track the "active" scroll
local current_timer = nil

local function smooth_scroll(percentage, duration_ms)
  -- 1. If a scroll is already happening, stop it immediately
  if current_timer then
    if not current_timer:is_closing() then
      current_timer:stop()
      current_timer:close()
    end
    current_timer = nil
  end

  local height = vim.api.nvim_win_get_height(0)
  local total_lines = math.floor(height * math.abs(percentage))
  if total_lines == 0 then return end

  local delay = math.floor(duration_ms / total_lines)
  local key = percentage > 0 and [[<C-e>]] or [[<C-y>]]
  local scroll_cmd = vim.api.nvim_replace_termcodes(key, true, false, true)
  
  -- Create a new timer
  current_timer = vim.uv.new_timer()
  local count = 0
  
  -- Use a local reference to the timer inside the callback to be safe
  local timer_to_close = current_timer

  current_timer:start(0, delay, vim.schedule_wrap(function()
    if count < total_lines then
      -- Check if buffer/window is still valid before feeding keys
      if vim.api.nvim_win_is_valid(0) then
        vim.api.nvim_feedkeys(scroll_cmd, 'n', true)
      end
      count = count + 1
    else
      -- 2. Safety check: Only close if it's not already closing
      if timer_to_close and not timer_to_close:is_closing() then
        timer_to_close:stop()
        timer_to_close:close()
      end
      if current_timer == timer_to_close then
        current_timer = nil
      end
    end
  end))
end

-- Mappings
local modes = { 'n', 'v', 'x', 'i' }
for _, mode in ipairs(modes) do
  vim.keymap.set(mode, '<PageDown>', function()
    smooth_scroll(0.2, 70)
  end, { desc = "Smooth scroll down" })

  vim.keymap.set(mode, '<PageUp>', function()
    smooth_scroll(-0.2, 70)
  end, { desc = "Smooth scroll up" })
end
