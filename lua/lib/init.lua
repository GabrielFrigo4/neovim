-- ----------------------------------------------------------------
-- Module: NeoVim Library Loader
-- ----------------------------------------------------------------

local root = vim.g.config_root or vim.fn.stdpath('config')
local path = root .. '/lua/lib'

if vim.uv.fs_stat(path) then
	for name, type in vim.fs.dir(path) do
		if type == 'file' and name:match('%.lua$') and name ~= 'init.lua' then
			local module_name = name:gsub('%.lua$', '')
			require('lib.' .. module_name)
		end
	end
end
