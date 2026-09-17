#!/usr/bin/env sh
# ----------------------------------------------------------------
# Interface: NeoVim Modal Editor Component
# ----------------------------------------------------------------
set -eu

_NVIM_ROOT="$(cd "$(dirname "$0")" && pwd)"

_nvim_help() {
	cat <<- EOF
		NeoVim — Interface Unificada de Componente

		Uso:
		  neovim.sh [comando]

		Comandos:
		  test      Valida inicializacao limpa do NeoVim em modo headless
		  doctor    Verifica presenca do binario nvim e ambiente
		  help      Exibe esta mensagem de ajuda
	EOF
}

_nvim_test() {
	echo "🧪 [NeoVim] Validando inicialização headless..."
	if command -v nvim > "/dev/null" 2>&1; then
		nvim --headless -u "${_NVIM_ROOT}/init.lua" -c "quit" > "/dev/null" 2>&1 && echo "  ✅ NeoVim: headless OK"
	else
		echo "ℹ️  nvim não encontrado no PATH; ignorando teste headless."
	fi
}

_nvim_doctor() {
	echo "🔍 [NeoVim] Diagnóstico do componente..."
	if command -v nvim > "/dev/null" 2>&1; then
		echo "  ✅ nvim detectado: $(command -v nvim)"
		nvim --version | head -n 1 | sed 's/^/     /'
	else
		echo "  ❌ nvim não encontrado no PATH."
	fi
}

_cmd="${1:-help}"
case "${_cmd}" in
	test|headless) _nvim_test ;;
	doctor)        _nvim_doctor ;;
	help|-h|--help) _nvim_help ;;
	*)
		echo "❌ Comando desconhecido: ${_cmd}" >&2
		_nvim_help >&2
		exit 1
		;;
esac
