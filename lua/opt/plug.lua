-- ----------------------------------------------------------------
-- Module: NeoVim Vim-Plug Loader
-- ----------------------------------------------------------------

if vim.fn.exists('*plug#begin') == 1 then
	Nvim.plug.init()
	Nvim.plug.close()
end
