# ⚡ Universal NeoVim Configuration

> Configuração modular, declarativa e resiliente do NeoVim com arquitetura FHS em Lua, Lazy.nvim, Mason LSP e tema Kanagawa.

[![Environment](https://img.shields.io/badge/🏛️_Environment-Hub-blue)](https://github.com/GabrielFrigo4/environment)
[![NeoVim](https://img.shields.io/badge/NeoVim-0.10%2B-green?logo=neovim&logoColor=white)](https://neovim.io/)
[![Lua](https://img.shields.io/badge/Lua-5.1_%2F_LuaJIT-blue?logo=lua&logoColor=white)](init.lua)
[![License](https://img.shields.io/badge/License-MIT-green?logo=open-source-initiative&logoColor=white)](LICENSE)

---

## 🧭 Visão Geral

Este repositório contém a configuração oficial do **NeoVim** de Gabriel Frigo, integrando a **Suíte de Editores** do [Universal Environment](https://github.com/GabrielFrigo4/environment). A estrutura adota a convenção de hierarquia UNIX FHS (`etc/`, `lib/`, `opt/`) para clareza e manutenção desacoplada.

- **Modularidade & Resiliência:** Carregamento protegido com `pcall` em `lua/opt/init.lua` para garantir inicialização sem falhas.
- **Ecossistema Lazy.nvim:** Instalação e gestão declarativa e assíncrona de plugins.
- **Mason LSP:** Gestão e autoconfiguração de Language Servers com fallback de capabilities.
- **Tema Kanagawa:** Visual relaxante e tema com fallback silencioso para `habamax` / `default`.

---

## 📁 Catálogo da Estrutura

| Diretório / Arquivo                | Descrição                                                                       |
| :--------------------------------- | :------------------------------------------------------------------------------ |
| [`neovim.sh`](neovim.sh)           | Interface unificada de componente (CLI para test, doctor, update)               |
| [`init.lua`](init.lua)             | Ponto de entrada que carrega em ordem `lib`, `etc` e `opt`                      |
| [`lua/etc/`](lua/etc/)             | Opções do editor (`options.lua`), atalhos (`keymaps.lua`), autocmds e clipboard |
| [`lua/lib/`](lua/lib/)             | Bibliotecas auxiliares e utilitários (`nvim.lua`)                               |
| [`lua/opt/`](lua/opt/)             | Plugins: `lazy.lua`, `lsp.lua` (Mason), `treesitter.lua`, `plug.lua`            |
| [`AGENTS.md`](AGENTS.md)           | Briefing arquitetural para agentes de inteligência artificial                   |
| [`PRINCIPLES.md`](PRINCIPLES.md)   | Os 18 Princípios de Engenharia UNIX + Clean Code                                |
| [`ENVIRONMENT.md`](ENVIRONMENT.md) | Manifesto do ecossistema Universal Environment                                  |

---

## 🚀 Instalação e Uso Rápido

### Opção A — Modo Versionado (Recomendado para Manutenção)

Clona o repositório diretamente no destino canônico com controle de versão Git ativo, permitindo atualizações automáticas contínuas via `uped` ou `git pull`.

#### 🐧 Unix (Linux, FreeBSD, macOS)

```sh
git clone "https://github.com/GabrielFrigo4/neovim.git" "${HOME}/.config/nvim"
```

#### 🪟 Windows (PowerShell Nativo)

```powershell
git clone "https://github.com/GabrielFrigo4/neovim.git" "$env:LOCALAPPDATA\nvim"
```

#### 🪟 Windows (MSYS2 / Git Bash)

```sh
git clone "https://github.com/GabrielFrigo4/neovim.git" "${HOME}/.config/nvim"
```

---

### Opção B — Modo Standalone Limpo (Zero-Bloat / Produção)

> [!TIP]
> **Filosofia Zero-Bloat:** Ideal para servidores, contêineres ou computadores de terceiros onde o controle de versão Git e artefatos de desenvolvimento não são necessários. Clona a árvore rasa (`--depth=1`) e remove metadados (`.git*`, `.agents`, `*.md`), deixando apenas a configuração estritamente executável.

#### 🐧 Unix (Linux, FreeBSD, macOS & MSYS2)

```sh
git clone --depth=1 "https://github.com/GabrielFrigo4/neovim.git" "${HOME}/.config/nvim" && \
  rm -rf "${HOME}/.config/nvim/.git"* "${HOME}/.config/nvim/.agents" "${HOME}/.config/nvim/"*.md
```

#### 🪟 Windows (PowerShell)

```powershell
git clone --depth=1 "https://github.com/GabrielFrigo4/neovim.git" "$env:LOCALAPPDATA\nvim"
Remove-Item -Recurse -Force "$env:LOCALAPPDATA\nvim\.git*", "$env:LOCALAPPDATA\nvim\.agents", "$env:LOCALAPPDATA\nvim\*.md" -ErrorAction SilentlyContinue
```

---

### ⚙️ Integração com o Universal Environment

Quando operado a partir do [Universal Environment](https://github.com/GabrielFrigo4/environment):

```sh
# Atualizar a suíte de editores com o upstream
make uped

# Implantar o repositório no destino canônico (~/.config/nvim)
make deploy
```

---

### 🔍 Validação Headless

```sh
nvim --headless -c "quit"
```
