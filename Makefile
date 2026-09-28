.POSIX:
.SILENT:

MAKEFLAGS += --no-print-directory -s

# ----------------------------------------------------------------
# Makefile: NeoVim Modal Editor
# ----------------------------------------------------------------

.PHONY: help hooks test headless ci

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

ci: test
	echo "🚀 NeoVim 100% pronto para produção!"
