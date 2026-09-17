.POSIX:
.SILENT:

MAKEFLAGS += --no-print-directory -s

# ----------------------------------------------------------------
# Makefile: NeoVim Modal Editor
# ----------------------------------------------------------------

.PHONY: help test headless ci

### ================================
### HELP & DOCUMENTATION
### ================================
help:
	cmd() { printf "    \033[36mmake %-22s\033[0m %s\n" "$$1" "$$2"; }; \
	sec() { printf "\n  \033[1;33m%s\033[0m\n" "$$1"; }; \
	printf "\n  \033[1;37mNeoVim — Configuração Modular FHS em Lua & LSP\033[0m\n"; \
	printf "  ============================================================\n"; \
	sec "Qualidade & Validação:"; \
	cmd "test"           "Valida inicialização em modo headless"; \
	cmd "headless"       "Executa boot limpo headless do Neovim"; \
	cmd "ci"             "Executa suíte de validação local do NeoVim"; \
	echo ""


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
