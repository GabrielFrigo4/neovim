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
local set_cur_tone
local set_cur
local tty_out = io.open('/dev/tty', 'w')

if vim.env.TERM ~= 'linux' then
	local cursor_group = Nvim.api.nvim_create_augroup('ConfigCursor', { clear = true })
	if not vim.g.is_raw_tty then
		Nvim.api.nvim_create_autocmd({ 'VimEnter', 'VimResume' }, {
			group = cursor_group,
			pattern = '*',
			command = 'set guicursor=n-v-sm:block,i-ci:ver25,c:ver25,r-cr:hor50,o:hor50,ve:ver35,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor',
		})
	else
		vim.opt.guicursor = ''
	end

	local base_cursor_color = nil
	local base_cursor_bg = nil

	local function resolve_base_colors()
		if base_cursor_color and base_cursor_bg then
			return base_cursor_color, base_cursor_bg
		end
		local hl = vim.api.nvim_get_hl(0, { name = 'Cursor' })
		local norm = vim.api.nvim_get_hl(0, { name = 'Normal' })
		local col = hl.bg or hl.fg or norm.fg or (vim.o.background == 'light' and 0x000000 or 0xffffff)
		local bg = norm.bg or (vim.o.background == 'light' and 0xffffff or 0x000000)
		base_cursor_color = col
		base_cursor_bg = bg
		return base_cursor_color, base_cursor_bg
	end

	Nvim.api.nvim_create_autocmd({ 'ColorScheme' }, {
		group = cursor_group,
		pattern = '*',
		callback = function()
			base_cursor_color = nil
			base_cursor_bg = nil
		end,
	})

	local function scale_tone(alpha)
		local col, bg = resolve_base_colors()
		local cr = bit.band(bit.rshift(col, 16), 0xff)
		local cg = bit.band(bit.rshift(col, 8), 0xff)
		local cb = bit.band(col, 0xff)
		local br = bit.band(bit.rshift(bg, 16), 0xff)
		local bg_g = bit.band(bit.rshift(bg, 8), 0xff)
		local bb = bit.band(bg, 0xff)
		local nr = math.min(255, math.max(0, math.floor(cr * alpha + br * (1.0 - alpha) + 0.5)))
		local ng = math.min(255, math.max(0, math.floor(cg * alpha + bg_g * (1.0 - alpha) + 0.5)))
		local nb = math.min(255, math.max(0, math.floor(cb * alpha + bb * (1.0 - alpha) + 0.5)))
		return string.format('#%02x%02x%02x', nr, ng, nb)
	end

	set_cur_tone = function(factor)
		local hex = scale_tone(factor)
		local _, bg = resolve_base_colors()
		pcall(vim.api.nvim_set_hl, 0, 'Cursor', { fg = bg, bg = hex })
		local osc = string.format('\27]12;%s\7', hex)
		if tty_out then
			pcall(function()
				tty_out:write(osc)
				tty_out:flush()
			end)
		end
		pcall(function()
			io.stdout:write(osc)
			io.stdout:flush()
		end)
		pcall(function()
			io.stderr:write(osc)
			io.stderr:flush()
		end)
		pcall(vim.api.nvim_chan_send, vim.v.stderr, osc)
	end

	Nvim.api.nvim_create_autocmd({ 'VimEnter' }, {
		group = cursor_group,
		pattern = '*',
		callback = function()
			set_cur_tone(1.0)
		end,
	})
	Nvim.api.nvim_create_autocmd({ 'ModeChanged' }, {
		group = cursor_group,
		pattern = '*:i*',
		callback = function()
			set_cur_tone(0.92)
		end,
	})
	Nvim.api.nvim_create_autocmd({ 'ModeChanged' }, {
		group = cursor_group,
		pattern = { '*:r*', '*:R*', '*:o*' },
		callback = function()
			set_cur_tone(0.76)
		end,
	})
	Nvim.api.nvim_create_autocmd({ 'ModeChanged' }, {
		group = cursor_group,
		pattern = { '*:v*', '*:V*', '*:\22*', '*:s*', '*:S*', '*:\19*' },
		callback = function()
			set_cur_tone(0.68)
		end,
	})
	Nvim.api.nvim_create_autocmd({ 'ModeChanged' }, {
		group = cursor_group,
		pattern = '*:n*',
		callback = function()
			set_cur_tone(1.0)
		end,
	})
	Nvim.api.nvim_create_autocmd({ 'CmdlineEnter' }, {
		group = cursor_group,
		pattern = '*',
		callback = function()
			set_cur_tone(0.84)
		end,
	})
	Nvim.api.nvim_create_autocmd({ 'CmdlineLeave' }, {
		group = cursor_group,
		pattern = '*',
		callback = function()
			set_cur_tone(1.0)
		end,
	})
	Nvim.api.nvim_create_autocmd({ 'VimLeave', 'VimSuspend' }, {
		group = cursor_group,
		pattern = '*',
		callback = function()
			if not vim.g.is_raw_tty then
				pcall(vim.api.nvim_chan_send, vim.v.stderr, '\27[1 q')
			end
			local reset_osc = '\27]112\7'
			if tty_out then
				pcall(function()
					tty_out:write(reset_osc)
					tty_out:flush()
					tty_out:close()
				end)
			end
			pcall(function()
				io.stdout:write(reset_osc)
				io.stdout:flush()
			end)
			pcall(function()
				io.stderr:write(reset_osc)
				io.stderr:flush()
			end)
			pcall(vim.api.nvim_chan_send, vim.v.stderr, reset_osc)
		end,
	})
else
	vim.opt.guicursor = ''
	local tty_cursor_grp = Nvim.api.nvim_create_augroup('LinuxTTYCursor', { clear = true })
	local tty_fd = io.open('/dev/tty', 'w')
	set_cur = function(code)
		local function emit()
			if tty_fd then
				pcall(function()
					tty_fd:write(code)
					tty_fd:flush()
				end)
			end
			pcall(function()
				io.stdout:write(code)
				io.stdout:flush()
			end)
			pcall(vim.api.nvim_chan_send, vim.v.stderr, code)
		end
		emit()
		vim.schedule(emit)
		vim.defer_fn(emit, 15)
	end
	Nvim.api.nvim_create_autocmd({ 'InsertEnter' }, {
		group = tty_cursor_grp,
		pattern = '*',
		callback = function()
			set_cur('\27[?2c')
		end,
	})
	Nvim.api.nvim_create_autocmd({ 'InsertLeave' }, {
		group = tty_cursor_grp,
		pattern = '*',
		callback = function()
			set_cur('\27[?6c')
		end,
	})
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
			if tty_fd then
				pcall(function()
					tty_fd:close()
				end)
			end
		end,
	})
end

local waiting_replace = false
vim.on_key(function(key, typed)
	local m = vim.fn.mode()
	if waiting_replace then
		waiting_replace = false
		if vim.env.TERM == 'linux' then
			if set_cur then
				set_cur(m == 'i' and '\27[?2c' or '\27[?6c')
			end
		else
			if set_cur_tone then
				set_cur_tone(m == 'i' and 0.92 or 1.0)
			end
			if not vim.g.is_raw_tty then
				local shape = (m == 'i') and '\27[5 q' or '\27[1 q'
				if tty_out then
					pcall(function()
						tty_out:write(shape)
						tty_out:flush()
					end)
				end
				pcall(function()
					io.stdout:write(shape)
					io.stdout:flush()
				end)
				pcall(vim.api.nvim_chan_send, vim.v.stderr, shape)
			end
		end
	elseif (m == 'n' or m == 'niI') and typed == 'r' then
		waiting_replace = true
		if vim.env.TERM == 'linux' then
			if set_cur then
				set_cur('\27[?4c')
			end
		else
			if set_cur_tone then
				set_cur_tone(0.76)
			end
			if not vim.g.is_raw_tty then
				local shape = '\27[3 q'
				if tty_out then
					pcall(function()
						tty_out:write(shape)
						tty_out:flush()
					end)
				end
				pcall(function()
					io.stdout:write(shape)
					io.stdout:flush()
				end)
				pcall(vim.api.nvim_chan_send, vim.v.stderr, shape)
			end
		end
	end
end)

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
