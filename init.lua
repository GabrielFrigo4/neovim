-- ----------------------------------------------------------------
-- Module: NeoVim Entry Point
-- ----------------------------------------------------------------

vim.o.background = "dark"

local term = vim.env.TERM or ""
local is_raw_tty = vim.env.RAW_TTY == "1"
	or term == "linux"
	or term == "cons25"
	or term:match("^vt%d+") ~= nil
	or (vim.env.DISPLAY == nil
		and vim.env.WAYLAND_DISPLAY == nil
		and vim.env.SSH_CONNECTION == nil
		and vim.env.SSH_TTY == nil
		and term ~= ""
		and not term:match("xterm%-256color")
		and not term:match("alacritty")
		and not term:match("kitty")
		and not term:match("foot")
		and not term:match("wezterm")
		and not term:match("ghostty"))

vim.g.is_raw_tty = is_raw_tty
if is_raw_tty then
	vim.o.ttyfast = false
	vim.opt.termguicolors = false
end

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
