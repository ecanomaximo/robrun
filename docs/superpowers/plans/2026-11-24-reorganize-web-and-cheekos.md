# Reorganização da Arquitetura Web e Segregação Cheekos DEV / VENDA Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reorganizar a estrutura de arquivos do projeto em pastas dedicadas (`public/`, `CHEEKOS_DEV/`, `CHEEKOS_CLIENT/`, `tools/`, `raw_assets/`), configurar o Firebase Hosting para servir a partir de `public/` e garantir a segregação funcional entre a versão interna de desenvolvimento e a versão comercial protegida por chave.

**Architecture:** Mover todos os arquivos públicos do site para `public/` com `firebase.json` apontando para `"public": "public"`. Criar `CHEEKOS_DEV` com inicializador direto sem key e `CHEEKOS_CLIENT` com pacote limpo de logs e ativação com key. Atualizar `empacotar.bat` para gerar `public/MR_RobRun_Client.zip`.

**Tech Stack:** Firebase Hosting, PowerShell / Batch scripts, Python, HTML5 / CSS3 / JS.

**Spec:** Aprovado pelo usuário na conversa em 24/11/2026.

## Global Constraints
- Nenhuma URL do site pode quebrar (`/`, `/planos`, `/chat`, `/MR_RobRun_Client.zip`).
- Todos os links relativos de assets (`clips/`, `img/`, `logo_mr*.png`, etc.) devem continuar funcionando sem erro 404.
- A versão `CHEEKOS_CLIENT` deve conter o validador `activate.ps1` e não conter logs volumosos (`hotkeys.log`, etc.).
- A versão `CHEEKOS_DEV` deve executar `RRX.exe` diretamente sem pedir chave.

---

### Task 1: Criar pasta `public/` e migrar todos os arquivos do site Web

**Files:**
- Create/Move: `public/index.html`, `public/planos.html`, `public/chat.html`, `public/clips/`, `public/img/`, `public/logo_mr*`, `public/favicon.*`, `public/*-bg.jpg`, `public/MR_RobRun_Client.zip`
- Modify: `firebase.json`

- [ ] **Step 1: Criar diretório `public/` e mover arquivos web**
- [ ] **Step 2: Atualizar `firebase.json` para `"public": "public"`**
- [ ] **Step 3: Testar localmente se arquivos estão íntegros em `public/`**

---

### Task 2: Estruturar as versões Cheekos DEV e Cheekos CLIENT

**Files:**
- Create: `CHEEKOS_DEV/` com `START.bat` (sem chamada de `activate.ps1`)
- Create: `CHEEKOS_CLIENT/` com `START.bat` (com `activate.ps1`), binários limpos e sem logs
- Modify: `empacotar.bat`

- [ ] **Step 1: Criar `CHEEKOS_DEV/` com script de inicialização direta**
- [ ] **Step 2: Criar `CHEEKOS_CLIENT/` limpo de logs, com `activate.ps1` e binários**
- [ ] **Step 3: Atualizar `empacotar.bat` para empacotar `CHEEKOS_CLIENT/` em `public/MR_RobRun_Client.zip`**
- [ ] **Step 4: Executar `empacotar.bat` e validar conteúdo do zip gerado**

---

### Task 3: Organizar ferramentas e ativos brutos (`tools/` e `raw_assets/`)

**Files:**
- Create: `tools/` (`gerar_chaves.py`, `chaves_venda.txt`)
- Create: `raw_assets/` (`clips mrcheats/`, `CHEEKOS.zip`)

- [ ] **Step 1: Mover utilitários para `tools/`**
- [ ] **Step 2: Mover ativos brutos/backups para `raw_assets/`**
- [ ] **Step 3: Limpar a pasta antiga `CHEEKOS` original após confirmação das novas pastas**

---

### Task 4: Deploy no Firebase Hosting e Validação Final

**Files:**
- Test & Deploy: `public/` via Firebase CLI

- [ ] **Step 1: Realizar deploy com `npx firebase-tools deploy --only hosting`**
- [ ] **Step 2: Verificar resposta HTTP 200 das rotas `/`, `/planos`, `/chat` e `/MR_RobRun_Client.zip`**
- [ ] **Step 3: Atualizar `checkpoint.md` e registrar status final**
