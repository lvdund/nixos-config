local lazy_module_names = {
  'plugins.fzf-lua',
  'plugins.csv',
  'plugins.debug',
  'plugins.languages',
  'plugins.tmux',
}

local always_module_names = {
  'plugins.themes',
  'plugins.treesitter',
  'plugins.notifications',
  'plugins.pairs_surround',
  'plugins.auto-code',
  'plugins.nvim-tree',
  'plugins.git',
  'plugins.status-info',
  'plugins.bufferline',
  'plugins.replace',
  'plugins.whichkey',
}

local function collect(mod_name)
  local ok, mod = pcall(require, mod_name)
  if not ok or not mod.specs then
    return nil
  end
  local plugin_names = {}
  for _, spec in ipairs(mod.specs) do
    plugin_names[#plugin_names + 1] = spec.name or spec.src:match('([^/]+)$')
  end
  return { mod = mod, plugin_names = plugin_names }
end

local always_specs = {}
local always_entries = {}
for _, mod_name in ipairs(always_module_names) do
  local entry = collect(mod_name)
  if entry then
    for _, spec in ipairs(entry.mod.specs) do
      always_specs[#always_specs + 1] = spec
    end
    always_entries[#always_entries + 1] = entry
  end
end

local lazy_specs = {}
local lazy_entries = {}
for _, mod_name in ipairs(lazy_module_names) do
  local entry = collect(mod_name)
  if entry then
    for _, spec in ipairs(entry.mod.specs) do
      lazy_specs[#lazy_specs + 1] = spec
    end
    lazy_entries[#lazy_entries + 1] = entry
  end
end

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if kind ~= 'install' and kind ~= 'update' then
      return
    end

    if name == 'nvim-treesitter' then
      vim.system({ 'nvim', '--headless', '-c', 'TSUpdate', '-c', 'qa' }, { cwd = ev.data.path }):wait()
    elseif name == 'LuaSnip' then
      if vim.fn.executable('make') == 1 then
        vim.system({ 'make', 'install_jsregexp' }, { cwd = ev.data.path }):wait()
      end
    end
  end,
})

vim.pack.add(always_specs, { load = true })

for _, entry in ipairs(always_entries) do
  if entry.mod.setup then
    entry.mod.setup()
  end
end

vim.pack.add(lazy_specs, { load = false })

for _, entry in ipairs(lazy_entries) do
  if not entry.mod.load_on then
    goto continue
  end

  local loaded = false
  local plugin_names = entry.plugin_names

  local function load_fn()
    if loaded then
      return
    end
    loaded = true
    for _, pname in ipairs(plugin_names) do
      vim.cmd.packadd(pname)
    end
    if entry.mod.setup then
      entry.mod.setup()
    end
  end

  entry.mod.load_on(load_fn)

  ::continue::
end
