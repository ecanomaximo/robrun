# Checkpoint do Projeto

## Status Atual
- **Status:** Concluído com sucesso (Arquitetura reorganizada em pastas modulares, segregação DEV/VENDA implementada e deploy validado).

## O que foi feito
1. **Reorganização Completa da Arquitetura de Arquivos:**
   - Pasta `public/`: Centraliza 100% dos ativos do site web (`index.html`, `planos.html`, `chat.html`, `clips/`, `img/`, favicons, logos, backgrounds e o pacote `MR_RobRun_Client.zip`).
   - Configuração do Firebase: `firebase.json` atualizado para `"public": "public"`.
   - Pasta `CHEEKOS_DEV/`: Versão para desenvolvedor, executa `RRX.exe` direto sem verificação de licença, sem pedir chave e sem amarrar HWID.
   - Pasta `CHEEKOS_CLIENT/`: Versão comercial limpa e enxuta, sem logs pesados residuais, contendo `START.bat` protegido com `activate.ps1` (HMAC SHA-256 + HWID).
   - Pasta `tools/`: Armazena gerador de chaves criptográficas (`gerar_chaves.py`) e arquivos de lotes de keys (`chaves_venda.txt`).
   - Pasta `raw_assets/`: Armazena gravações brutas (`clips_mrcheats_raw`), backups antigos (`CHEEKOS_LEGACY_DIR`) e `.zip` legado.
   - Script `empacotar.bat` na raiz: Atualizado para gerar de forma nativa e automática o pacote limpo `public/MR_RobRun_Client.zip` a partir de `CHEEKOS_CLIENT/`.
2. **Deploy e Validação:**
   - Realizado deploy no Firebase Hosting do site `mrcheats`.
   - Todas as rotas e ativos testados e respondendo 200 OK:
     - `https://mrcheats.web.app`
     - `https://mrcheats.web.app/planos`
     - `https://mrcheats.web.app/chat`
     - `https://mrcheats.web.app/MR_RobRun_Client.zip`
     - `https://mrcheats.web.app/clips/clip1.mp4`
     - `https://mrcheats.web.app/favicon.ico`
     - `https://mrcheats.web.app/logo_mr.png`

## Onde parou
- Estrutura de pastas 100% limpa, separada e em produção.

## Contexto Atual
- Raiz do projeto: Apenas 5 pastas (`public`, `CHEEKOS_DEV`, `CHEEKOS_CLIENT`, `tools`, `raw_assets`) e 5 arquivos de controle (`.firebaserc`, `.gitignore`, `firebase.json`, `empacotar.bat`, `checkpoint.md`).
- Cliente ZIP: Atualizado e disponível diretamente na URL `/MR_RobRun_Client.zip` para os clientes do bot.

## Próximos Passos
- Conectar a função `gerar_key_mr` ao bot do Discord/Stripe para entrega automatizada de keys de 7D, 30D ou Vitalício.
