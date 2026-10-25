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
	if term == "linux" and vim.fn.executable("tic") == 1 then
		local terminfo_path = vim.fs.normalize("~/.terminfo/l/linux")
		if vim.uv.fs_stat(terminfo_path) == nil then
			local src = "linux|linux console with sanitized cursor,\n\tcnorm=\\E[?25h,\n\tcvvis=\\E[?25h,\n\tcivis=\\E[?25l,\n\tuse=linux,\n"
			local out_dir = vim.fs.normalize("~/.terminfo")
			vim.fn.mkdir(out_dir, "p")
			vim.fn.system({ "tic", "-o", out_dir, "-" }, src)
		end
	end
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
