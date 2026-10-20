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
elseif not vim.g.is_raw_tty then
	Nvim.cmd('let &t_SI = "\\<Esc>[6 q"')
	Nvim.cmd('let &t_SR = "\\<Esc>[4 q"')
	Nvim.cmd('let &t_EI = "\\<Esc>[2 q"')
	Nvim.cmd('let &t_te = "\\<Esc>[2 q"')
end

Nvim.global.polyglot_disabled = { 'ftdetect', 'ada' }

Nvim.option.backspace:append('indent', 'eol', 'start')
Nvim.option.whichwrap:append('<>hl[]')

Nvim.option.mouse = 'a'
Nvim.option.mousemodel = 'popup'

Nvim.guioption = 'adegmrLT'
Nvim.option.clipboard:append('unnamed', 'unnamedplus')

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

local is_raw_tty = vim.g.is_raw_tty == true

if is_raw_tty then
	vim.o.ttyfast = false
end
Nvim.option.cursorcolumn = not is_raw_tty
Nvim.option.cursorline = true
Nvim.option.termguicolors = not is_raw_tty
