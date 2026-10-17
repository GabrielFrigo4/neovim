-- ----------------------------------------------------------------
-- Module: NeoVim Core Options
-- ----------------------------------------------------------------

Nvim.option.compatible = false
Nvim.cmd('filetype plugin indent on')
Nvim.cmd('syntax on')

if vim.env.TERM == 'linux' then
	Nvim.cmd('let &t_SI = "\\<Esc>[?2c"')
	Nvim.cmd('let &t_SR = "\\<Esc>[?4c"')
	Nvim.cmd('let &t_EI = "\\<Esc>[?6c"')
	Nvim.cmd('let &t_te = "\\<Esc>[?6c"')
else
	Nvim.cmd('let &t_SI = "\\<Esc>[5 q"')
	Nvim.cmd('let &t_SR = "\\<Esc>[3 q"')
	Nvim.cmd('let &t_EI = "\\<Esc>[1 q"')
end

Nvim.global.polyglot_disabled = { 'ftdetect', 'ada' }

Nvim.option.backspace:append('indent', 'eol', 'start')
Nvim.option.whichwrap:append('<>hl[]')

Nvim.option.mouse = 'a'
Nvim.option.mousemodel = 'popup'

Nvim.guioption = 'adegmrLT'
Nvim.option.clipboard:append('unnamed', 'unnamedplus')

Nvim.option.cursorcolumn = true
Nvim.option.cursorline = true

Nvim.option.relativenumber = true
Nvim.option.inccommand = 'split'

Nvim.option.preserveindent = true
Nvim.option.autoindent = true
Nvim.option.copyindent = true

Nvim.option.expandtab = false
Nvim.option.softtabstop = 4
Nvim.option.shiftwidth = 4
Nvim.option.tabstop = 4

Nvim.option.smartcase = true
Nvim.option.encoding = 'UTF-8'

local term = vim.env.TERM or ''
local is_raw_tty = vim.env.RAW_TTY == '1'
	or term == 'linux'
	or term == 'cons25'
	or term:match('^vt%d+') ~= nil
	or (vim.env.DISPLAY == nil
		and vim.env.WAYLAND_DISPLAY == nil
		and vim.env.SSH_CONNECTION == nil
		and vim.env.SSH_TTY == nil
		and term ~= ''
		and not term:match('xterm%-256color')
		and not term:match('alacritty')
		and not term:match('kitty')
		and not term:match('foot')
		and not term:match('wezterm')
		and not term:match('ghostty'))

Nvim.option.termguicolors = not is_raw_tty
