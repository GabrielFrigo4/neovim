---
name: universal-neovim
description: Runbook operacional para desenvolvimento, auditoria, testes headless e gestão do ecossistema Lua/Lazy.nvim na configuração do NeoVim. Use ao adicionar novos plugins, ajustar servidores Mason LSP, refatorar atalhos ou diagnosticar inicialização headless.
---

# ⚡ Universal NeoVim — Runbook Operacional

Este runbook orienta desenvolvedores e agentes de inteligência artificial na manutenção, teste, auditoria e sincronização da configuração modular do **NeoVim (0.10+)**.

---

## 🏛️ Diretrizes & Baseline Arquitetural

1. **Baseline: NeoVim 0.10+ & Lua 5.1/LuaJIT:**
    - Aproveita recursos nativos do NeoVim 0.10+ (`vim.lsp`, `vim.treesitter`, `vim.keymap.set`, `vim.opt`).
    - Arquitetura FHS modular em Lua:
        - `init.lua`: Ponto de entrada que delega o carregamento na ordem `lib` ➔ `etc` ➔ `opt`.
        - `lua/etc/`: Opções gerais (`options.lua`), atalhos globais (`keymaps.lua`), eventos (`autocmds.lua`) e integração com clipboard.
        - `lua/lib/`: Utilitários auxiliares (`nvim.lua`).
        - `lua/opt/`: Gerenciador Lazy.nvim (`lazy.lua`), servidores Mason LSP (`lsp.lua`), TreeSitter (`treesitter.lua`) e plugins sob demanda.
2. **Resiliência e Proteção com `pcall`:** Módulos de plugins em `lua/opt/init.lua` são carregados com tratamento defensivo de erro (`pcall`) para garantir inicialização sem falhas mesmo na ausência de pacotes externos.
3. **Zero Symlinks Manuais:** O repositório opera como clone soberano em `${HOME}/.config/nvim` (Unix/MSYS2) ou `%LOCALAPPDATA%\nvim` (Windows nativo).

---

## 🧪 1. Validação em Modo Headless

Sempre teste a inicialização limpa do NeoVim antes de efetuar commits ou concluir alterações:

```sh
# Via Makefile canônico
make test

# Ou via script unificado de componente
./neovim.sh test

# Ou diretamente via comando nvim headless
nvim --headless -u init.lua -c "quit"
```

> [!IMPORTANT]
> O processo DEVE encerrar com código de retorno `0` e zero mensagens de erro ou tracebacks no `stderr`.

---

## 🔍 2. Diagnóstico do Ambiente (`doctor`)

Para inspecionar o runtime e a versão do binário:

```sh
./neovim.sh doctor
```

Dentro de uma sessão interativa do NeoVim:

```vim
:checkhealth
```

---

## 📦 3. Gerenciamento de Plugins com Lazy.nvim

- **Sincronizar Plugins:** `:Lazy sync` (atualiza e limpa plugins conforme a especificação declarativa).
- **Inspecionar Status:** `:Lazy` (abre o painel interativo de gerenciamento).
- **Verificar Atualizações:** `:Lazy check`.
- **Limpar Plugins Removidos:** `:Lazy clean`.

---

## 🌐 4. Gestão de LSP e TreeSitter via Mason

- **Painel Geral de LSPs:** `:Mason`
- **Status da Conexão LSP:** `:LspInfo`
- **Atualizar Gramáticas TreeSitter:** `:TSUpdate` ou `:TreeSitterSetup`
- **Reiniciar Servidor de Linguagem:** `:LspRestart`

---

## 🚀 5. Sincronização & Deploy Soberano

O repositório opera de forma independente ou orquestrado pelo **Universal Environment**:

```sh
# A partir do Universal Environment (orquestrador pai)
make uped    # Atualiza a suite de editores
make deploy  # Sincroniza clones nos destinos canonicos

# Ou clonagem direta e limpa
git clone "https://github.com/GabrielFrigo4/neovim.git" "${HOME}/.config/nvim"
```

---

## 🔗 Links Oficiais de Referência

- [NeoVim Official Documentation](https://neovim.io/doc/)
- [NeoVim Lua Guide](https://neovim.io/doc/user/lua-guide.html)
- [Lazy.nvim Plugin Manager](https://github.com/folke/lazy.nvim)
- [Mason.nvim Package Manager](https://github.com/williamboman/mason.nvim)
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
