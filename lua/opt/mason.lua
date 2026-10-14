-- ----------------------------------------------------------------
-- Module: NeoVim Mason & Language Server Protocol Integration
-- ----------------------------------------------------------------

local servers = {
	"asm_lsp", "clangd", "zls", "rust_analyzer", "gopls",
	"jdtls", "metals", "clojure_lsp", "pyright", "lua_ls",
	"ts_ls", "html", "cssls", "neocmake", "yamlls",
	"lemminx", "jsonls", "bashls", "sqlls",
}

local tools = { "shellcheck", "shfmt" }

local registry_info = {
	asm_lsp       = { mason = "asm-lsp", bin = "asm-lsp", ft = { "asm", "vmasm", "nasm" } },
	clangd        = { mason = "clangd", bin = "clangd", ft = { "c", "cpp", "objc", "objcpp", "cuda", "proto" } },
	zls           = { mason = "zls", bin = "zls", ft = { "zig", "zir" } },
	rust_analyzer = { mason = "rust-analyzer", bin = "rust-analyzer", ft = { "rust" } },
	gopls         = { mason = "gopls", bin = "gopls", ft = { "go", "gomod", "gowork", "gotmpl" } },
	jdtls         = { mason = "jdtls", bin = "jdtls", ft = { "java" } },
	metals        = { mason = "metals", bin = "metals", ft = { "scala", "sbt" } },
	clojure_lsp   = { mason = "clojure-lsp", bin = "clojure-lsp", ft = { "clojure", "edn" } },
	pyright       = { mason = "pyright", bin = "pyright-langserver", ft = { "python" } },
	lua_ls        = { mason = "lua-language-server", bin = "lua-language-server", ft = { "lua" } },
	ts_ls         = { mason = "typescript-language-server", bin = "typescript-language-server", ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" } },
	html          = { mason = "html-lsp", bin = "vscode-html-language-server", ft = { "html" } },
	cssls         = { mason = "css-lsp", bin = "vscode-css-language-server", ft = { "css", "scss", "less" } },
	neocmake      = { mason = "neocmakelsp", bin = "neocmakelsp", ft = { "cmake" } },
	yamlls        = { mason = "yaml-language-server", bin = "yaml-language-server", ft = { "yaml" } },
	lemminx       = { mason = "lemminx", bin = "lemminx", ft = { "xml" } },
	jsonls        = { mason = "json-lsp", bin = "vscode-json-language-server", ft = { "json", "jsonc" } },
	bashls        = { mason = "bash-language-server", bin = "bash-language-server", ft = { "sh", "bash" } },
	sqlls         = { mason = "sqlls", bin = "sql-language-server", ft = { "sql", "mysql" } },
	shellcheck    = { mason = "shellcheck", bin = "shellcheck" },
	shfmt         = { mason = "shfmt", bin = "shfmt" },
}

local has_cmp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
local default_caps = has_cmp and cmp_lsp.default_capabilities() or vim.lsp.protocol.make_client_capabilities()

-- ================================
-- CONFIGURACOES CUSTOMIZADAS
-- ================================
local server_configs = {
	clangd = {
		cmd = {
			"clangd", "--background-index", "--clang-tidy",
			"--completion-style=detailed", "--header-insertion=iwyu", "--fallback-style=llvm",
		},
		root_dir = function(fname)
			return Nvim.filesys.root(fname, { ".git", "Makefile", "compile_commands.json" })
		end,
	},

	rust_analyzer = {
		settings = {
			["rust-analyzer"] = {
				check = { command = "clippy" },
				cargo = { allFeatures = true },
			},
		},
	},

	gopls = {
		settings = {
			gopls = { analyses = { unusedparams = true }, staticcheck = true },
		},
	},

	lua_ls = {
		settings = {
			Lua = {
				diagnostics = { globals = { 'vim', 'Nvim' } },
				workspace = { checkThirdParty = false },
			},
		},
	},

	bashls = {
		settings = {
			bashIde = { shellcheckPath = "shellcheck", shfmt = { path = "shfmt" } },
		},
	},

	asm_lsp = {
		settings = {
			assembler = { name = "nasm", file_types = { "s", "S", "asm", "inc", "nasm", "ninc" } },
			instruction = { syntax = "intel" },
		},
		handlers = {
			["window/showMessage"] = function(err, result, ctx, config)
				if result and result.message and result.message:find("No .asm-lsp.toml", 1, true) then
					return
				end
				vim.lsp.handlers["window/showMessage"](err, result, ctx, config)
			end,
		},
	},

	pyright = {
		cmd = { "pyright-langserver", "--stdio" },
	},
}

-- ================================
-- FUNCOES AUXILIARES
-- ================================
local function get_mason_name(name)
	local info = registry_info[name]
	return (info and info.mason) or name
end

local function get_binary_name(name)
	local info = registry_info[name]
	return (info and info.bin) or name
end

local function is_system_available(name)
	local bin = get_binary_name(name)
	return Nvim.func.executable(bin) == 1
end

local function is_mason_available(name)
	local ok_reg, registry = pcall(require, "mason-registry")
	if not ok_reg then return false end
	local mason_name = get_mason_name(name)
	local ok, pkg = pcall(registry.get_package, mason_name)
	return ok and pkg and pkg:is_installed()
end

local function resolve_server_availability(name)
	if is_system_available(name) then return true end
	return is_mason_available(name)
end

local function build_opts(name)
	local opts = { capabilities = default_caps }
	local info = registry_info[name]
	if info and info.ft then opts.filetypes = info.ft end

	local custom = server_configs[name]
	if custom then
		for k, v in pairs(custom) do opts[k] = v end
	end

	if not opts.cmd then opts.cmd = { get_binary_name(name) } end
	return opts
end

local function register_autocmd(opts)
	if opts.filetypes then
		Nvim.api.nvim_create_autocmd("FileType", {
			pattern = opts.filetypes,
			callback = function(ev)
				Nvim.lsp.start(opts, { bufnr = ev.buf })
			end,
		})
	end
end

-- ================================
-- INSTALACAO DE SERVIDORES
-- ================================
local function install_servers()
	local ok_reg, registry = pcall(require, "mason-registry")
	if not ok_reg then
		print("Mason registry is not available yet. Run :Lazy to install plugins first.")
		return
	end
	print("Mason LSP & Tools Install Start...")

	local all_targets = {}
	for _, name in ipairs(servers) do table.insert(all_targets, name) end
	for _, name in ipairs(tools) do table.insert(all_targets, name) end

	for _, name in ipairs(all_targets) do
		if is_system_available(name) then
			print("System Found: " .. name)
		else
			local pkg_name = get_mason_name(name)
			local ok, pkg = pcall(registry.get_package, pkg_name)

			if ok and pkg and not pkg:is_installed() then
				print("Mason Installing: " .. pkg_name)
				pkg:install():once("closed", function()
					print("Mason Done: " .. pkg_name)
				end)
			end
		end
	end
end

Nvim.api.nvim_create_user_command('LSPInstall', install_servers,
	{ nargs = 0, desc = 'Install configured LSP servers and tools via Mason' }
)

-- ================================
-- INICIALIZACAO DE SERVIDORES
-- ================================
local function setup_servers()
	pcall(require("mason").setup)

	for _, name in ipairs(servers) do
		pcall(function()
			if resolve_server_availability(name) then
				local opts = build_opts(name)
				register_autocmd(opts)
			end
		end)
	end
end

setup_servers()

Nvim.api.nvim_create_user_command('LSPLoad', setup_servers,
	{ nargs = 0, desc = 'Reload configured LSP servers' }
)
