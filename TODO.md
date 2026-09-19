# 🗺️ Roadmap & Backlog

> Planejamento estratégico, status operacional e visão de futuro para a evolução do **Universal NeoVim**.

---

## 📊 Status do Projeto

| Área                             |   Status   | Cobertura / Estado                                             |
| :------------------------------- | :--------: | :------------------------------------------------------------- |
| **🏛️ Arquitetura FHS Lua**       | 🟢 Estável | Divisão modular e limpa em `lua/lib/`, `lua/etc/` e `lua/opt/` |
| **🛡️ Resiliência & Fail-safe**   | 🟢 Estável | Carregamento protegido com `pcall` sem interrupções por erros  |
| **📦 Gerenciador Lazy.nvim**     | 🟢 Estável | Carregamento assíncrono e sob demanda de plugins               |
| **⚡ Mason LSP & Treesitter**    | 🟢 Estável | Servidores LSP auto-instaláveis e realce de sintaxe preciso    |
| **🎨 Tema Kanagawa & Fallbacks** | 🟢 Estável | Visual moderno com fallback automático para temas nativos      |
| **🧪 Validação Headless no CI**  |  🟢 100%   | Inicialização headless validada via `nvim --headless`          |

---

## 🎯 Grandes Épicos & Backlog

### 1. ⚡ Desempenho & Otimização de Inicialização

- [ ] Otimizar lazy-loading de plugins pesados visando boot < 25ms.
- [ ] Realizar profiling de startup contínuo no CI (`nvim --startuptime`).

### 2. 🛠️ Cobertura de Linguagens & Mason

- [ ] Adicionar receitas Mason pré-configuradas para C23, Go, Rust, Lua e Shell POSIX.
- [ ] Refinar integração de formatadores via `conform.nvim` ou formatadores nativos LSP.

### 3. 🌐 Experiência Multiplataforma & Terminal

- [ ] Garantir paridade total entre Linux, FreeBSD, macOS e Windows nativo (`$env:LOCALAPPDATA\nvim`).
- [ ] Aprimorar atalhos de integração com clipboard do sistema operacional.

---

> [!TIP]
> Para detalhes sobre convenções de código e diretrizes de engenharia, consulte o [PRINCIPLES.md](PRINCIPLES.md) e o [ENVIRONMENT.md](ENVIRONMENT.md).
