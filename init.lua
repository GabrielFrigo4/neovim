-- ----------------------------------------------------------------
-- Module: NeoVim Entry Point
-- ----------------------------------------------------------------

local source = debug.getinfo(1, "S").source
local config_root = (source:sub(1, 1) == "@") and vim.fs.dirname(vim.fs.normalize(source:sub(2))) or vim.fn.stdpath("config")

if config_root and config_root ~= "" then
	vim.opt.rtp:prepend(config_root)
	local lua_path = config_root .. "/lua"
	package.path = lua_path .. "/?.lua;" .. lua_path .. "/?/init.lua;" .. package.path
	vim.g.config_root = config_root
end

require('lib')
require('etc')
require('opt')
