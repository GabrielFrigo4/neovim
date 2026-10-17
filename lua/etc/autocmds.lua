-- ----------------------------------------------------------------
-- Module: NeoVim Autocommands & Filetype Bindings
-- ----------------------------------------------------------------

local function setExtCmd(extension, command)
	Nvim.autocmd({ 'BufNewFile', 'BufRead' }, {
		pattern = extension,
		command = command,
	})
end

local function setListExtCmd(list)
	for i = 1, #list, 1 do
		local extCmd = list[i]
		setExtCmd(extCmd[1], extCmd[2])
	end
end

-- ================================
-- SINTAXE
-- ================================
local x86 = {
	{ { '*.x86', '*.x64', '*.xinc' }, 'set ft=nasm' },
	{ { '*.X86', '*.X64', '*.Xinc' }, 'set ft=nasm' },
	{ { '*.masm', '*.minc' },         'set ft=masm' },
	{ { '*.nasm', '*.ninc' },         'set ft=nasm' },
	{ { '*.fasm', '*.finc' },         'set ft=fasm' },
	{ { '*.gas', '*.ginc' },          'set ft=asm' },
	{ { '*.s', '*.i' },               'set ft=nasm' },
	{ { '*.S', '*.I' },               'set ft=nasm' },
}
setListExtCmd(x86)

local arm = {
	{ { '*.arm', '*.ainc' }, 'set ft=arm' },
	{ { '*.ARM', '*.AINC' }, 'set ft=arm' },
}
setListExtCmd(arm)

local riscv = {
	{ { '*.riscv', '*.rinc' }, 'set ft=riscv' },
	{ { '*.RISCV', '*.RINC' }, 'set ft=riscv' },
}
setListExtCmd(riscv)

if Nvim.isWin then
	setExtCmd({ '*.asm', '*.inc' }, 'set ft=masm')
end

if Nvim.isUnix then
	setExtCmd({ '*.asm', '*.inc' }, 'set ft=nasm')
end

-- ================================
-- TAB INDENT
-- ================================
local tabs = {
	'.org', '.norg',
	'*.asm', '*.inc',
	'*.masm', '*.minc',
	'*.nasm', '*.ninc',
	'*.fasm', '*.finc',
	'*.gas', '*.ginc',
	'*.s', '*.i',
	'*.S', '*.I',
	'*.x86', '*.x64', '*.xinc',
	'*.X86', '*.X64', '*.Xinc',
	'*.arm', '*.ainc',
	'*.ARM', '*.AINC',
	'*.riscv', '*.rinc',
	'*.RISCV', '*.RINC',
	'*.py', '.pyw',
	'*.lua', '*.wlua',
	'*.rs',
	'*.zig',
}
setExtCmd(tabs, 'set noet ci pi sts=4 sw=4 ts=4')

-- ================================
-- UI & FOLDING
-- ================================
local cursor_group = Nvim.api.nvim_create_augroup('ConfigCursor', { clear = true })
Nvim.api.nvim_create_autocmd({ 'VimEnter', 'VimResume' }, {
	group = cursor_group,
	pattern = '*',
	command = 'set guicursor=n-c:block,i-ci-ve:ver10,r-v:hor10,a:blinkwait500-blinkoff500-blinkon500-Cursor/lCursor'
})
Nvim.api.nvim_create_autocmd({ 'VimLeave', 'VimSuspend' }, {
	group = cursor_group,
	pattern = '*',
	command = 'set guicursor='
})

if vim.env.TERM == 'linux' then
	local tty_cursor_grp = Nvim.api.nvim_create_augroup('LinuxTTYCursor', { clear = true })
	Nvim.api.nvim_create_autocmd({ 'ModeChanged' }, {
		group = tty_cursor_grp,
		pattern = '*:i*',
		callback = function()
			io.stdout:write('\27[?2c')
		end,
	})
	Nvim.api.nvim_create_autocmd({ 'ModeChanged' }, {
		group = tty_cursor_grp,
		pattern = '*:c*',
		callback = function()
			io.stdout:write('\27[?3c')
		end,
	})
	Nvim.api.nvim_create_autocmd({ 'ModeChanged' }, {
		group = tty_cursor_grp,
		pattern = '*:[rR]*',
		callback = function()
			io.stdout:write('\27[?4c')
		end,
	})
	Nvim.api.nvim_create_autocmd({ 'ModeChanged' }, {
		group = tty_cursor_grp,
		pattern = '*:[vV\22sS\19]*',
		callback = function()
			io.stdout:write('\27[?5c')
		end,
	})
	Nvim.api.nvim_create_autocmd({ 'ModeChanged' }, {
		group = tty_cursor_grp,
		pattern = '*:n*',
		callback = function()
			io.stdout:write('\27[?6c')
		end,
	})
	Nvim.api.nvim_create_autocmd({ 'VimLeave', 'VimSuspend' }, {
		group = tty_cursor_grp,
		pattern = '*',
		callback = function()
			io.stdout:write('\27[?6c')
		end,
	})
end

local ft_vim_grp = Nvim.api.nvim_create_augroup('FileTypeVim', { clear = true })
Nvim.api.nvim_create_autocmd('FileType', {
	group = ft_vim_grp,
	pattern = 'vim',
	callback = function()
		Nvim.opt_local.foldmethod = 'marker'
	end
})
