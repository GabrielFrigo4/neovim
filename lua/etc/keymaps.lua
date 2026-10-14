-- ----------------------------------------------------------------
-- Module: NeoVim Keymaps & Mappings
-- ----------------------------------------------------------------

Nvim.global.mapleader = '\\'
Nvim.global.maplocalleader = Nvim.global.mapleader

Nvim.keymap.set('n', '<Backspace>', function()
	if Nvim.func.col('.') == 1 then
		return 'kgJ'
	else
		return 'X'
	end
end, { expr = true, replace_keycodes = true, desc = "Smart Backspace" })

local function nrmap(shortcut, command, description)
	Nvim.keymap.set('', shortcut, command, { desc = description, noremap = true, silent = true })
end

nrmap('<M-.>', '<C-]>')
nrmap('<M-,>', '<C-o>')

nrmap('<S-tab>', '<C-w>w')
nrmap('<M-]>', '<C-w>w')
nrmap(';', '<C-w>w')
nrmap('<M-up>', '<C-w><up>')
nrmap('<M-down>', '<C-w><down>')
nrmap('<M-left>', '<C-w><left>')
nrmap('<M-right>', '<C-w><right>')

nrmap('<leader>pi', ':PlugInstall<cr>')
nrmap('<leader>pu', ':PlugUpdate<cr>')
nrmap('<leader>urp', ':UpdateRemotePlugins<cr>')

nrmap('<C-\\>', ':NvimTreeToggle<cr>')
nrmap('<M-[>', ':NvimTreeToggle<cr>')
nrmap(',', ':NvimTreeToggle<cr>')

nrmap('<C-t>', '<Nop>', 'Enable <C-t> for Telescope')

nrmap('<C-t>f', '<cmd>Telescope find_files<cr>', 'Telescope Find Files')
nrmap('<C-t>g', '<cmd>Telescope live_grep<cr>', 'Telescope Live Grep')
nrmap('<C-t>b', '<cmd>Telescope buffers<cr>', 'Telescope Buffers')
nrmap('<C-t>t', '<cmd>Telescope help_tags<cr>', 'Telescope Help Tags')

nrmap('<leader>y', '"+y', 'Yank to system clipboard')
nrmap('<leader>Y', '"+Y', 'Yank line to system clipboard')
nrmap('<leader>p', '"+p', 'Paste from system clipboard')
nrmap('<leader>P', '"+P', 'Paste before from system clipboard')
Nvim.keymap.set('v', '<leader>y', '"+y', { desc = 'Yank selection to system clipboard', noremap = true, silent = true })
Nvim.keymap.set('v', '<leader>p', '"+p', { desc = 'Paste over selection from system clipboard', noremap = true, silent = true })
