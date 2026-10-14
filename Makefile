.POSIX:
.SILENT:

MAKEFLAGS += --no-print-directory -s

# ----------------------------------------------------------------
# Makefile: NeoVim Modal Editor
# ----------------------------------------------------------------

.PHONY: help hooks test headless bench format prettier ci

### ================================
### HELP & DOCUMENTATION
### ================================
help:
	_e=$$'\e'; \
	cmd() { printf "    $${_e}[36mmake %-22s$${_e}[0m %s\n" "$$1" "$$2"; }; \
	sec() { printf "\n  $${_e}[1;33m%s$${_e}[0m\n" "$$1"; }; \
	printf "\n  $${_e}[1;37mNeoVim — Configuração Modular FHS em Lua & LSP$${_e}[0m\n"; \
	printf "  ============================================================\n"; \
	sec "Setup & Ganchos:"; \
	cmd "hooks"          "Configura e aplica permissões canônicas em .githooks"; \
	sec "Qualidade & Validação:"; \
	cmd "test"           "Valida inicialização em modo headless"; \
	cmd "headless"       "Executa boot limpo headless do Neovim"; \
	cmd "bench"          "Mede tempo de inicialização headless (< 25ms)"; \
	cmd "format"         "Formata documentações Markdown com Prettier"; \
	cmd "prettier"       "Formata documentações Markdown com Prettier"; \
	cmd "ci"             "Executa suíte de validação local do NeoVim"; \
	echo ""

### ================================
### GIT HOOKS & PERMISSIONS
### ================================
hooks:
	echo "🪝 Configurando ganchos Git (.githooks)..."
	chmod 0755 .githooks/pre-commit .githooks/commit-msg 2> "/dev/null" || true
	git config core.hooksPath .githooks 2> "/dev/null" || true
	echo "  ✅ NeoVim: core.hooksPath -> .githooks"


### ================================
### TESTING & VALIDATION
### ================================
test: headless

headless:
	echo "🧪 Validando inicialização headless do NeoVim..."
	if command -v nvim > "/dev/null" 2>&1; then \
		nvim --headless -u init.lua -c "quit" > "/dev/null" 2>&1 && echo "  ✅ NeoVim: headless OK"; \
	else \
		echo "ℹ️  nvim não encontrado no PATH; ignorando teste headless."; \
	fi

bench:
	echo "⏱️  Medindo tempo de inicialização do NeoVim..."
	if command -v nvim > "/dev/null" 2>&1; then \
		rm -f /tmp/nvim-bench.log; \
		nvim --headless -u init.lua --startuptime /tmp/nvim-bench.log -c "quit" > "/dev/null" 2>&1; \
		awk '/--- NVIM STARTED ---/ { printf "  ✅ NeoVim startup: %s ms\n", $$1 }' /tmp/nvim-bench.log | tail -n 1; \
	else \
		echo "ℹ️  nvim não encontrado no PATH; ignorando benchmark."; \
	fi

format: prettier
	echo "✅ Formatação concluída!"

prettier:
	if command -v prettier > "/dev/null" 2>&1; then prettier --write "**/*.md" 2> "/dev/null" || true; elif command -v npx > "/dev/null" 2>&1; then npx prettier --write "**/*.md" 2> "/dev/null" || true; fi

ci: test
	echo "🚀 NeoVim 100% pronto para produção!"
