# ⚡ NeoVim Engineering Principles & Guidelines

> Regras de engenharia e diretrizes de desenvolvimento para a configuração do NeoVim.

---

## 🏛️ Invariantes de Código Lua no NeoVim

1. **Robustez no Carregamento:** Todo `require()` em módulos opcionais ou de terceiros (`mason`, `cmp`, `telescope`, `treesitter`) deve ser executado de forma protegida (`pcall`) com valores default seguros.
2. **Separação FHS:**
    - `etc/`: Apenas opções, atalhos e autocmds de core.
    - `lib/`: Apenas funções puras e utilitários reutilizáveis.
    - `opt/`: Apenas setups de plugins externos.
3. **Arquitetura de Comentários em 3 Camadas:**
    - Topo: Header Banner com 64 `-` (`-- --------------------------------...`).
    - Seções: Delimitador com 32 `=` (`-- ================================`).
    - Subseções: Delimitador com 32 `-` (`-- --------------------------------`).
    - Sem comentários redundantes dentro das funções.
4. **Performance de Inicialização:**
    - Startup em headless (`nvim --headless +qa`) deve ser instantâneo e silencioso.
