# ⚡ NeoVim Configuration — AI Agent Briefing

> Este é o repositório da **configuração do NeoVim** de Gabriel Frigo, integrante da **Suíte de Editores** do ecossistema [Universal Environment](https://github.com/GabrielFrigo4/environment).

---

## 🧭 Identidade e Papel

O repositório `nvim` provê um ambiente de desenvolvimento modal moderno baseado em Lua, estruturado sob uma convenção inspirada no Filesystem Hierarchy Standard (FHS) do UNIX (`lua/etc/`, `lua/lib/`, `lua/opt/`), com Lazy.nvim, Mason LSP, Telescope, Treesitter e tema Kanagawa.

---

## 📁 Estrutura Canônica de Diretórios

- **`init.lua`**: Ponto de entrada que carrega em ordem `lib`, `etc` e `opt`.
- **`lua/etc/`**: Configurações de sistema e sessão:
    - `options.lua`: Opções globais (`vim.opt`).
    - `keymaps.lua`: Mapeamentos de teclas.
    - `autocmds.lua`: Autocomandos e triggers de eventos.
    - `clipboard.lua`: Sincronização multi-plataforma de clipboard.
- **`lua/lib/`**: Bibliotecas e helpers utilitários (`nvim.lua`).
- **`lua/opt/`**: Módulos de plugins e gerenciadores:
    - `init.lua`: Carregador resiliente com `pcall`.
    - `lazy.lua`: Bootstrap e especificações declarativas do Lazy.nvim.
    - `lsp.lua`: Configuração do Mason, handlers e servidores LSP.
    - `treesitter.lua`: Gramáticas e setup do Treesitter.
    - `plug.lua`: Compatibilidade com vim-plug legado.

---

## ⚠️ Invariantes Críticas para Agentes de IA

1. **Fail-Safe & Graceful Degradation:** O carregamento de módulos e plugins DEVE utilizar `pcall` ou checagens seguras para que o Neovim inicialize sem mensagens de erro obstrutivas mesmo em ambientes novos ou sem internet.
2. **Tema Fallback:** Se `kanagawa` não estiver instalado, o editor deve fazer fallback para `habamax` ou `default` sem lançar erro.
3. **Zero Comentários Narrativos:** Mantenha a arquitetura de comentários em 3 camadas e sem comentários inline óbvios.
4. **Zero Secrets:** Tokens e segredos não pertencem ao repositório do Neovim.
5. **Hermetismo de Produção & Invariante `rm -rf .agents`:** Repositório 100% autônomo. Zero acoplamento de código de produção a `.agents/` ou `skills/` (o editor opera plenamente se `.agents/` for deletado).

---

---

## 🛡️ Regra da Proatividade e Correção Contínua (Boy Scout Rule)

O agente de IA **DEVE SER ATIVAMENTE PROATIVO** na manutenção e aplicação dos padrões canônicos deste repositório.

Se durante a execução de qualquer tarefa (seja criação de novas features, correções pontuais, refatorações ou investigação) o agente identificar qualquer linha de código, script, Makefile ou documentação fora dos padrões estabelecidos, **NÃO DEVE HESITAR NEM IGNORAR**:

1. **Notificar concisamente** o usuário sobre a divergência encontrada.
2. **Corrigir imediatamente a inconformidade**, aplicando o padrão canônico correspondente:
    - **Comentários Narrativos:** Eliminar imediatamente comentários óbvios que apenas narram código executável.
    - **Banners Estruturais:** Ajustar réguas para exatamente 64 hífens no topo ou 32 caracteres com `### ` no corpo.
    - **Portabilidade POSIX:** Substituir bashismos (`[[ ]]`, `&>`, arrays, `source`) por sintaxe estrita POSIX `/bin/sh`.
    - **Shebang Universal:** Garantir sempre `#!/usr/bin/env sh` ou `#!/usr/bin/env python3`.
    - **Sequências ANSI:** Substituir octais crípticos (``) e `printf` desnecessário por `[ -t 1 ] && echo -n $'\e...'`.
    - **Redirecionamento Seguro:** Envolver destinos em aspas duplas (ex: `> "/dev/null" 2>&1`).
    - **Makefiles:** Assegurar cabeçalho `.POSIX: .SILENT:`, `MAKEFLAGS += --no-print-directory -s`, alinhamento estético de variáveis e zero `@` redundante.
    - **Permissões Canônicas:** Aplicar 4 dígitos octais (`chmod 0755`, `chmod 0644`, `chmod 0700`, `chmod 0600`).

## 📖 Referências Obrigatórias

- **[ENVIRONMENT.md](ENVIRONMENT.md)**: Arquitetura global do ecossistema
- **[PRINCIPLES.md](PRINCIPLES.md)**: Os 18 Princípios de Engenharia UNIX + Clean Code
- **[.agents/rules/principles.md](.agents/rules/principles.md)**: Regras específicas para o NeoVim
- **[.agents/skills/](.agents/skills/)**: Runbooks operacionais do NeoVim
