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
if vim.env.TERM ~= 'linux' and not vim.g.is_raw_tty then
	local cursor_group = Nvim.api.nvim_create_augroup('ConfigCursor', { clear = true })
	Nvim.api.nvim_create_autocmd({ 'VimEnter', 'VimResume' }, {
		group = cursor_group,
		pattern = '*',
		command = 'set guicursor=n-v-sm:block,i-ci:ver25,c:ver25,r-cr:hor50,o:hor50,ve:ver35,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor',
	})
	Nvim.api.nvim_create_autocmd({ 'VimLeave', 'VimSuspend' }, {
		group = cursor_group,
		pattern = '*',
		command = 'set guicursor= | call chansend(v:stderr, "\\<Esc>[1 q")',
	})
elseif vim.env.TERM ~= 'linux' then
	vim.opt.guicursor = ''
	local bsd_cursor_grp = Nvim.api.nvim_create_augroup('FreeBSDTTYCursor', { clear = true })
	local function scale_tone(factor)
		local hl = vim.api.nvim_get_hl(0, { name = 'Cursor' })
		local col = hl.bg or hl.fg
		if not col then
			local norm = vim.api.nvim_get_hl(0, { name = 'Normal' })
			col = norm.fg or 0xffffff
		end
		local r = bit.band(bit.rshift(col, 16), 0xff)
		local g = bit.band(bit.rshift(col, 8), 0xff)
		local b = bit.band(col, 0xff)
		local nr = math.min(255, math.max(0, math.floor(r * factor + 0.5)))
		local ng = math.min(255, math.max(0, math.floor(g * factor + 0.5)))
		local nb = math.min(255, math.max(0, math.floor(b * factor + 0.5)))
		return string.format('#%02x%02x%02x', nr, ng, nb)
	end
	local function set_cur_tone(factor)
		local hex = scale_tone(factor)
		local osc = string.format('\27]12;%s\7', hex)
		pcall(vim.api.nvim_chan_send, vim.v.stderr, osc)
		pcall(function()
			io.stderr:write(osc)
			io.stderr:flush()
		end)
	end
	Nvim.api.nvim_create_autocmd({ 'VimEnter' }, {
		group = bsd_cursor_grp,
		pattern = '*',
		callback = function()
			set_cur_tone(1.0)
		end,
	})
	Nvim.api.nvim_create_autocmd({ 'ModeChanged' }, {
		group = bsd_cursor_grp,
		pattern = '*:i*',
		callback = function()
			set_cur_tone(0.85)
		end,
	})
	Nvim.api.nvim_create_autocmd({ 'ModeChanged' }, {
		group = bsd_cursor_grp,
		pattern = { '*:r*', '*:R*' },
		callback = function()
			set_cur_tone(0.70)
		end,
	})
	Nvim.api.nvim_create_autocmd({ 'ModeChanged' }, {
		group = bsd_cursor_grp,
		pattern = { '*:v*', '*:V*', '*:\22*', '*:s*', '*:S*', '*:\19*' },
		callback = function()
			set_cur_tone(0.55)
		end,
	})
	Nvim.api.nvim_create_autocmd({ 'ModeChanged' }, {
		group = bsd_cursor_grp,
		pattern = '*:o*',
		callback = function()
			set_cur_tone(0.70)
		end,
	})
	Nvim.api.nvim_create_autocmd({ 'ModeChanged' }, {
		group = bsd_cursor_grp,
		pattern = '*:n*',
		callback = function()
			set_cur_tone(1.0)
		end,
	})
	Nvim.api.nvim_create_autocmd({ 'CmdlineEnter' }, {
		group = bsd_cursor_grp,
		pattern = '*',
		callback = function()
			set_cur_tone(0.85)
		end,
	})
	Nvim.api.nvim_create_autocmd({ 'CmdlineLeave' }, {
		group = bsd_cursor_grp,
		pattern = '*',
		callback = function()
			set_cur_tone(1.0)
		end,
	})
	Nvim.api.nvim_create_autocmd({ 'VimLeave', 'VimSuspend' }, {
		group = bsd_cursor_grp,
		pattern = '*',
		callback = function()
			pcall(vim.api.nvim_chan_send, vim.v.stderr, '\27]112\7')
			pcall(function()
				io.stderr:write('\27]112\7')
				io.stderr:flush()
			end)
		end,
	})
else
	vim.opt.guicursor = ''
	local tty_cursor_grp = Nvim.api.nvim_create_augroup('LinuxTTYCursor', { clear = true })
	local function set_cur(code)
		pcall(vim.api.nvim_chan_send, vim.v.stderr, code)
		pcall(function()
			io.stderr:write(code)
			io.stderr:flush()
		end)
	end
	Nvim.api.nvim_create_autocmd({ 'VimEnter' }, {
		group = tty_cursor_grp,
		pattern = '*',
		callback = function()
			set_cur('\27[?6c')
		end,
	})
	Nvim.api.nvim_create_autocmd({ 'ModeChanged' }, {
		group = tty_cursor_grp,
		pattern = '*:i*',
		callback = function()
			set_cur('\27[?2c')
		end,
	})
	Nvim.api.nvim_create_autocmd({ 'ModeChanged' }, {
		group = tty_cursor_grp,
		pattern = { '*:r*', '*:R*' },
		callback = function()
			set_cur('\27[?4c')
		end,
	})
	Nvim.api.nvim_create_autocmd({ 'ModeChanged' }, {
		group = tty_cursor_grp,
		pattern = { '*:v*', '*:V*', '*:\22*', '*:s*', '*:S*', '*:\19*' },
		callback = function()
			set_cur('\27[?5c')
		end,
	})
	Nvim.api.nvim_create_autocmd({ 'ModeChanged' }, {
		group = tty_cursor_grp,
		pattern = '*:o*',
		callback = function()
			set_cur('\27[?4c')
		end,
	})
	Nvim.api.nvim_create_autocmd({ 'ModeChanged' }, {
		group = tty_cursor_grp,
		pattern = '*:n*',
		callback = function()
			set_cur('\27[?6c')
		end,
	})
	local function set_cmdline_cur()
		set_cur('\27[?3c')
		vim.defer_fn(function()
			if vim.fn.getcmdtype() ~= '' then
				set_cur('\27[?3c')
			end
		end, 15)
	end
	Nvim.api.nvim_create_autocmd({ 'CmdlineEnter' }, {
		group = tty_cursor_grp,
		pattern = '*',
		callback = set_cmdline_cur,
	})
	Nvim.api.nvim_create_autocmd({ 'CmdlineChanged' }, {
		group = tty_cursor_grp,
		pattern = '*',
		callback = function()
			set_cur('\27[?3c')
		end,
	})
	Nvim.api.nvim_create_autocmd({ 'CmdlineLeave' }, {
		group = tty_cursor_grp,
		pattern = '*',
		callback = function()
			set_cur('\27[?6c')
		end,
	})
	Nvim.api.nvim_create_autocmd({ 'VimLeave', 'VimSuspend' }, {
		group = tty_cursor_grp,
		pattern = '*',
		callback = function()
			set_cur('\27%G\27[?16;238;0c')
		end,
	})
	local waiting_replace = false
	vim.on_key(function(key, typed)
		if waiting_replace then
			waiting_replace = false
			set_cur('\27[?6c')
		elseif vim.fn.mode() == 'n' and typed == 'r' then
			waiting_replace = true
			set_cur('\27[?4c')
		end
	end)
end

local ft_vim_grp = Nvim.api.nvim_create_augroup('FileTypeVim', { clear = true })
Nvim.api.nvim_create_autocmd('FileType', {
	group = ft_vim_grp,
	pattern = 'vim',
	callback = function()
		Nvim.opt_local.foldmethod = 'marker'
	end
})

if vim.g.is_raw_tty then
	local tty_mouse_grp = Nvim.api.nvim_create_augroup('RawTTYMouse', { clear = true })
	Nvim.api.nvim_create_autocmd({ 'VimEnter', 'VimResume' }, {
		group = tty_mouse_grp,
		pattern = '*',
		callback = function()
			pcall(vim.api.nvim_chan_send, vim.v.stderr, '\27[?1000h\27[?1002h\27[?1006h')
		end,
	})
	Nvim.api.nvim_create_autocmd({ 'VimLeave', 'VimSuspend' }, {
		group = tty_mouse_grp,
		pattern = '*',
		callback = function()
			pcall(vim.api.nvim_chan_send, vim.v.stderr, '\27[?1006l\27[?1002l\27[?1000l')
		end,
	})
end

local term_grp = Nvim.api.nvim_create_augroup('ConfigTerminal', { clear = true })
Nvim.api.nvim_create_autocmd('TermOpen', {
	group = term_grp,
	pattern = '*',
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.signcolumn = 'no'
		vim.cmd('startinsert')
	end,
})
