# 🤝 Guia de Contribuição — NeoVim Modular Suite

> Diretrizes de desenvolvimento, arquitetura Lua, Lazy.nvim, Mason LSP e quality gates para a configuração de **NeoVim**.

---

## 🚀 Setup Inicial da Bancada (Primeiros Passos)

Para clonar e configurar o repositório localmente com todos os ganchos e quality gates ativados:

```sh
# 1. Clonar o repositório
git clone "https://github.com/GabrielFrigo4/neovim.git" "${HOME}/Documents/NeoVim"
cd "${HOME}/Documents/NeoVim"

# 2. Configurar ganchos Git e permissões canônicas
make hooks

# 3. Validar inicialização headless limpa
make test

# 4. Executar a suíte de validação local
make ci
```

> [!IMPORTANT]
> O comando `make hooks` configura `core.hooksPath -> .githooks` e aplica permissões canônicas `0755` aos ganchos de pre-commit e commit-msg. Execute-o sempre após um novo clone.

---

## 🛡️ Invariantes de Engenharia no NeoVim

1. **Arquitetura Modular em Lua:**
    - `init.lua`: Ponto de entrada canônico enxuto.
    - `lua/core/`: Opções fundamentais (`options.lua`), atalhos globais (`keymaps.lua`) e autocommands (`autocmds.lua`).
    - `lua/plugins/`: Especificação declarativa de plugins para o gerenciador `lazy.nvim`.
    - `lua/lsp/`: Servidores de linguagem, Mason e autocompletion via Blink/Nvim-Cmp.

2. **Invariante de Clonagem "Out-of-the-Box" (Zero-Tweaks Invariant):**
    - Scripts executáveis (`neovim.sh`) devem possuir modo octal `100755` no Git Index.
    - Arquivos Lua, Vimscript (`.vim`), documentações e configurações devem possuir modo `100644`.
    - Se cometer um erro de modo no Git Index, corrija com:
        ```sh
        git update-index --chmod=+x neovim.sh
        git update-index --chmod=-x init.lua
        ```

3. **Hermetismo Headless:**
    - A configuração deve ser capaz de inicializar e sair limpa em modo headless (`nvim --headless -u init.lua -c "quit"`) sem travar ou emitir erros de quebra de runtime.

---

## 🪝 Quality Gates & Validação Local

O repositório possui validações automatizadas:

```sh
make test      # Testa inicialização headless limpa
make ci        # Executa bateria de qualidade completa
```

Ganchos Git em `.githooks/`:

- **`pre-commit`:** Verifica whitespace, modos octais no Git Index (0755 vs 0644), sintaxe Lua/shell e formatação.
- **`commit-msg`:** Valida formato semântico da mensagem de commit.

---

## 📝 Convenção de Commits Semânticos

As mensagens de commit devem seguir o formato:

```text
<tipo>(<escopo>): <descrição objetiva>
```

Tipos permitidos: `feat`, `fix`, `refactor`, `docs`, `style`, `test`, `ci`, `chore`.

---

## 📖 Referências Canônicas

- [README.md](README.md) — Visão geral da suíte NeoVim
- [PRINCIPLES.md](PRINCIPLES.md) — Princípios de Engenharia e Clean Code
- [AGENTS.md](AGENTS.md) — Briefing para agentes autônomos de IA
- [TODO.md](TODO.md) — Roadmap operacional do NeoVim
