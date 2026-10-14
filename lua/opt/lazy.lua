-- ----------------------------------------------------------------
-- Module: NeoVim Lazy Plugin Specifications
-- ----------------------------------------------------------------

Nvim.lazy.setup()
local lazy = require("lazy")

lazy.setup({
	spec = {
		-- ================================
		-- TEMA & VISUAL
		-- ================================
		{
			"rebelot/kanagawa.nvim",
			version = "*",
			lazy = false,
			priority = 1000,
			config = function()
				local is_tty = vim.env.RAW_TTY == "1" or vim.env.TERM == "linux" or vim.env.TERM == "cons25" or not vim.opt.termguicolors:get()
				if is_tty then
					local ok = pcall(Nvim.cmd.colorscheme, "habamax")
					if not ok then pcall(Nvim.cmd.colorscheme, "default") end
				else
					local ok = pcall(Nvim.cmd.colorscheme, "kanagawa-wave")
					if not ok then
						local fallback_ok = pcall(Nvim.cmd.colorscheme, "habamax")
						if not fallback_ok then pcall(Nvim.cmd.colorscheme, "default") end
					end
				end
			end,
		},
		{
			'nvim-lualine/lualine.nvim',
			version = "*",
			dependencies = { 'nvim-tree/nvim-web-devicons' },
			config = function()
				local is_tty = vim.env.RAW_TTY == "1" or vim.env.TERM == "linux" or vim.env.TERM == "cons25" or not vim.opt.termguicolors:get()
				local ok, lualine = pcall(require, 'lualine')
				if ok then
					lualine.setup({
						options = {
							theme = is_tty and 'auto' or 'kanagawa',
							icons_enabled = not is_tty,
						},
					})
				end
			end,
		},
		{
			"lukas-reineke/indent-blankline.nvim",
			version = "*",
			event = { "BufReadPost", "BufNewFile" },
			main = "ibl",
			opts = {},
		},

		-- ================================
		-- SINTAXE & HIGHLIGHT
		-- ================================
		{
			"nvim-treesitter/nvim-treesitter",
			event = { "BufReadPost", "BufNewFile" },
			cmd = { "TSUpdate", "TSInstall", "TreeSitterSetup" },
			build = ":TSUpdate",
			config = function()
				local ok, configs = pcall(require, "nvim-treesitter.configs")
				if ok then
					configs.setup({
						highlight = { enable = true },
						indent = { enable = true },
					})
				end
			end,
		},
		{
			"sheerun/vim-polyglot",
			lazy = false,
			config = function()
				Nvim.global.polyglot_disabled = { 'ftdetect' }
			end,
		},

		-- ================================
		-- GERENCIAMENTO DE ARQUIVOS
		-- ================================
		{
			"nvim-tree/nvim-tree.lua",
			version = "*",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFile" },
			opts = {
				sort = { sorter = "case_sensitive" },
				view = { width = 30 },
				renderer = { group_empty = true, indent_markers = { enable = true } },
				filters = { dotfiles = false },
			},
			config = function(_, opts)
				require("nvim-tree").setup(opts)
			end,
		},
		{
			"stevearc/oil.nvim",
			version = "*",
			dependencies = { "echasnovski/mini.icons" },
			cmd = { "Oil" },
			opts = {},
		},

		-- ================================
		-- FERRAMENTAS & EDICAO
		-- ================================
		{
			'nvim-telescope/telescope.nvim',
			version = "*",
			dependencies = { 'nvim-lua/plenary.nvim' },
			cmd = { "Telescope" },
			config = function()
				require('telescope').setup()
			end,
		},
		{
			"kylechui/nvim-surround",
			version = "*",
			event = "VeryLazy",
			config = function()
				require("nvim-surround").setup({})
			end
		},
		{
			'windwp/nvim-autopairs',
			version = "*",
			event = "InsertEnter",
			config = true
		},
		{
			"NeogitOrg/neogit",
			version = "*",
			dependencies = {
				"nvim-lua/plenary.nvim", "sindrets/diffview.nvim",
				"nvim-telescope/telescope.nvim", "ibhagwan/fzf-lua", "echasnovski/mini.pick",
			},
			cmd = { "Neogit" },
			config = true
		},
		{
			"smoka7/multicursors.nvim",
			dependencies = { "nvimtools/hydra.nvim" },
			event = "VeryLazy",
			opts = {},
			cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern" },
			keys = {
				{ mode = { "v", "n" }, "<Leader>m", "<cmd>MCstart<cr>", desc = "Multi Cursor" },
			},
		},
		{
			"stevearc/conform.nvim",
			version = "*",
			event = { "BufWritePre" },
			cmd = { "ConformInfo" },
			keys = {
				{
					"<leader>f",
					function()
						require("conform").format({ async = true, lsp_format = "fallback" })
					end,
					mode = "",
					desc = "Format buffer",
				},
			},
			opts = {
				formatters_by_ft = {
					javascript = { "prettier" }, typescript = { "prettier" },
					javascriptreact = { "prettier" }, typescriptreact = { "prettier" },
					css = { "prettier" }, html = { "prettier" }, json = { "prettier" },
					yaml = { "prettier" }, markdown = { "prettier" },
					c = { "clang_format" }, cpp = { "clang_format" },
					cuda = { "clang_format" }, java = { "clang_format" },
					cs = { "clang_format" }, scala = { "scalafmt" },
					clojure = { "cljfmt" }, lua = { "stylua" },
					go = { "gofmt", "goimports" },
					sh = { "shfmt" }, bash = { "shfmt" },
				},
				format_after_save = { lsp_format = "fallback" },
			},
		},

		-- ================================
		-- LSP & AUTOCOMPLETE
		-- ================================
		{
			"neovim/nvim-lspconfig",
			version = "*",
			dependencies = {
				"williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp",
			},
			config = function()
				require("mason").setup()
			end,
		},
		{
			'hrsh7th/nvim-cmp',
			version = "*",
			dependencies = {
				'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path',
				'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip',
			},
			config = function()
				local cmp = require('cmp')
				local luasnip = require('luasnip')
				cmp.setup({
					snippet = {
						expand = function(args) luasnip.lsp_expand(args.body) end,
					},
					mapping = cmp.mapping.preset.insert({
						['<C-b>'] = cmp.mapping.scroll_docs(-4),
						['<C-f>'] = cmp.mapping.scroll_docs(4),
						['<C-Space>'] = cmp.mapping.complete(),
						['<C-e>'] = cmp.mapping.abort(),
						['<CR>'] = cmp.mapping.confirm({ select = true }),
						['<Tab>'] = cmp.mapping.select_next_item(),
					}),
					sources = cmp.config.sources({
						{ name = 'nvim_lsp' }, { name = 'luasnip' },
					}, { { name = 'buffer' } }),
				})
			end,
		},

		-- ================================
		-- LINGUAGENS ESPECIFICAS
		-- ================================
		{ "GabrielFrigo4/fasm.vim", ft = "fasm" },
		{ "kylelaker/riscv.vim",    ft = "riscv" },
		{ "ARM9/arm-syntax-vim",    ft = "arm" },
		{ "thindil/vim-ada",        ft = "ada" },
	},

	-- ================================
	-- CONFIGURACAO GERAL
	-- ================================
	install = { colorscheme = { "kanagawa-wave" } },
	checker = { enabled = true, notify = false },
	change_detection = { notify = false },
	rocks = { enabled = false },
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin",
			},
		},
	},
})
