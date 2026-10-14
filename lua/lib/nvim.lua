-- ----------------------------------------------------------------
-- Module: NeoVim Core Table Variables & Helpers
-- ----------------------------------------------------------------

local uname = vim.uv.os_uname()
local sysname = uname.sysname:lower()

Nvim = {
	isWin = vim.fn.has('win32') == 1,
	isUnix = vim.fn.has('unix') == 1,
	isWsl = vim.fn.has('wsl') == 1,
	isMac = sysname == 'darwin',
	isLinux = sysname == 'linux',
	isBSD = sysname:find('bsd') ~= nil,
	sysname = sysname,

	var = vim.v,
	uv = vim.uv,
	api = vim.api,
	lsp = vim.lsp,
	global = vim.g,
	option = vim.opt,
	guioption = vim.go,
	winoption = vim.wo,
	keymap = vim.keymap,
	filesys = vim.fs,
	func = vim.fn,
	cmd = vim.cmd,
	notify = vim.notify,
	augroup = vim.api.nvim_create_augroup,
	autocmd = vim.api.nvim_create_autocmd,
	path = {
		lib = vim.api.nvim_list_runtime_paths()[3],
		appData = vim.api.nvim_list_runtime_paths()[1],
		shareRuntime = vim.api.nvim_list_runtime_paths()[2],
		binRuntime = vim.api.nvim_list_runtime_paths()[4],
		winOrUnix = function(strPath)
			if Nvim.isWin then
				strPath = strPath:gsub("/", "\\")
			elseif Nvim.isUnix then
				strPath = strPath:gsub("\\", "/")
			end
			return strPath
		end
	},

	plug = {
		get = function(...)
			if vim.fn.exists('*plug#') == 1 then
				Nvim.func['plug#'](...)
			end
		end,
		init = function()
			if vim.fn.exists('*plug#begin') == 1 then
				vim.call('plug#begin')
			end
		end,
		close = function()
			if vim.fn.exists('*plug#end') == 1 then
				vim.call('plug#end')
			end
		end,
	},

	lazy = {
		setup = function()
			local lazypath = Nvim.func.stdpath("data") .. "/lazy/lazy.nvim"
			if not Nvim.uv.fs_stat(lazypath) then
				local lazyrepo = "https://github.com/folke/lazy.nvim.git"
				local out = Nvim.func.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo,
					lazypath })
				if Nvim.var.shell_error ~= 0 then
					Nvim.api.nvim_echo({
						{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
						{ out,                            "WarningMsg" },
						{ "\nPress any key to exit..." },
					}, true, {})
					Nvim.func.getchar()
					os.exit(1)
				end
			end
			Nvim.option.rtp:prepend(lazypath)
		end,
	},
}
