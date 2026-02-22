local function on_attach(bufnr)
  local api = require 'nvim-tree.api'

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  vim.keymap.set('n', 'r', api.fs.rename, opts 'Rename')
  vim.keymap.set('n', 'm', api.marks.toggle, opts 'Toggle Bookmark')
  vim.keymap.set('n', ']e', api.node.navigate.diagnostics.next, opts 'Next Diagnostic')
  vim.keymap.set('n', '[e', api.node.navigate.diagnostics.prev, opts 'Prev Diagnostic')
  vim.keymap.set('n', 'd', api.fs.remove, opts 'Delete')
  vim.keymap.set('n', 'D', api.fs.trash, opts 'Trash')
  vim.keymap.set('n', 'y', api.fs.copy.node, opts 'Copy')
  vim.keymap.set('n', 'z', api.tree.collapse_all, opts 'Collapse All')
  vim.keymap.set('n', '<BS>', api.node.navigate.parent_close, opts 'Close Directory')
  vim.keymap.set('n', '<CR>', api.node.open.edit, opts 'Open')
  vim.keymap.set('n', 'S', api.tree.search_node, opts 'Search')
  vim.keymap.set('n', 'a', api.fs.create, opts 'Create File Or Directory')
  vim.keymap.set('n', '<Tab>', api.node.open.preview, opts 'Open Preview')
  vim.keymap.set('n', 'p', api.fs.paste, opts 'Paste')
  vim.keymap.set('n', 'P', api.node.navigate.parent, opts 'Parent Directory')
  vim.keymap.set('n', 'g?', api.tree.toggle_help, opts 'Help')
end

return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  lazy = false,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    { '\\', '<Cmd>NvimTreeFindFileToggle<CR>', desc = 'NvimTree toggle', silent = true },
  },
  config = function()
    require('nvim-tree').setup {
      on_attach = on_attach,
      view = {
        signcolumn = 'yes',
        float = {
          enable = true,
          open_win_config = function()
            local scr_w = vim.opt.columns:get()
            local scr_h = vim.opt.lines:get()
            local tree_w = 100
            local tree_h = math.floor(scr_h * 0.8)
            return {
              style = 'minimal',
              relative = 'editor',
              border = 'rounded',
              width = tree_w,
              height = tree_h,
              col = (scr_w - tree_w) / 2,
              row = (scr_h - tree_h) / 2,
            }
          end,
        },
        cursorline = false,
      },
      diagnostics = { enable = true },
      modified = { enable = true },
      renderer = {
        indent_width = 3,
        icons = {
          show = { hidden = true },
          git_placement = 'after',
          bookmarks_placement = 'after',
          symlink_arrow = ' -> ',
          glyphs = {
            symlink = '',
            bookmark = '',
            modified = '󰲶 ',
            hidden = '󰘓',
            git = {
              unstaged = '✗',
              staged = '✓',
              unmerged = '',
              renamed = '󰁕',
              untracked = '★',
              deleted = '󰷩 ',
              ignored = ' ',
            },
          },
        },
      },
      filters = { git_ignored = false },
      hijack_cursor = true,
      sync_root_with_cwd = true,
    }
  end,
}
