-- ----------------------------------------------------------------
-- Module: NeoVim Packages Loader
-- ----------------------------------------------------------------

local root = vim.g.config_root or vim.fn.stdpath('config')
local path = root .. '/lua/opt'

if not vim.uv.fs_stat(path) then
	return
end

local files = {}
for name, type in vim.fs.dir(path) do
	if type == 'file' and name:match('%.lua$') and name ~= 'init.lua' then
		table.insert(files, name)
	end
end

table.sort(files)

for i, name in ipairs(files) do
	if name == 'lazy.lua' then
		table.remove(files, i)
		table.insert(files, 1, 'lazy.lua')
		break
	end
end

for _, name in ipairs(files) do
	local module_name = name:gsub('%.lua$', '')
	local ok, err = pcall(require, 'opt.' .. module_name)
	if not ok then
		vim.notify('Failed to load opt.' .. module_name .. ': ' .. tostring(err), vim.log.levels.WARN)
	end
end
