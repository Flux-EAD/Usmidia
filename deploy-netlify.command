#!/bin/bash
#
# US MÍDIA — publicar na Netlify
#
# Dê dois cliques neste arquivo. Ele instala as dependências, roda o build
# completo da Netlify aqui na máquina (Next + plugin + função de servidor) e
# publica em produção.
#
# Na primeira vez o Netlify vai abrir uma página no navegador pedindo
# autorização. Clique em "Authorize" e volte para esta janela — o resto é
# automático.

cd "$(dirname "$0")" || exit 1

SITE="earnest-zabaione-8a3fb6"
NETLIFY="npx --yes netlify-cli@27"

linha() { printf '\n\033[1;34m▸ %s\033[0m\n' "$1"; }
erro()  { printf '\n\033[1;31m✗ %s\033[0m\n' "$1"; }

parar() {
  erro "$1"
  echo ""
  echo "Nada foi publicado. Manda essa janela pro Claude que a gente resolve."
  echo ""
  read -r -p "Pressione Enter para fechar."
  exit 1
}

printf '\033[1m\n  US MÍDIA — deploy na Netlify\n\033[0m'
echo "  pasta: $(pwd)"

# ── 1. Node ───────────────────────────────────────────────────────────────
linha "Verificando o Node"
command -v node >/dev/null 2>&1 || parar "Node não encontrado. Instale em https://nodejs.org"
echo "  node $(node -v) · npm $(npm -v)"

# ── 2. Dependências ───────────────────────────────────────────────────────
# `npm ci` instala exatamente o que está no package-lock.json — as mesmas
# versões que foram testadas. Se o lock estiver fora de sincronia com o
# package.json ele falha de propósito, e aí caímos no npm install.
linha "Instalando dependências"
if [ -f package-lock.json ]; then
  npm ci --no-audit --no-fund || npm install --no-audit --no-fund || parar "Falha ao instalar as dependências."
else
  npm install --no-audit --no-fund || parar "Falha ao instalar as dependências."
fi

# ── 3. Checagem de segurança ──────────────────────────────────────────────
# A Netlify BLOQUEIA deploy de projeto com vulnerabilidade crítica (foi o que
# derrubou o primeiro deploy: a CVE-2025-55182 no Next). Checamos antes de
# gastar o build.
linha "Checando vulnerabilidades críticas"
if npm audit --audit-level=critical --omit=dev >/dev/null 2>&1; then
  echo "  ok, nenhuma crítica"
else
  erro "Existe vulnerabilidade CRÍTICA nas dependências."
  echo "  A Netlify vai recusar o deploy. Rode 'npm audit' para ver, ou"
  echo "  peça pro Claude atualizar o Next/React antes de continuar."
  echo ""
  read -r -p "  Publicar mesmo assim? (digite: sim) " resposta
  [ "$resposta" = "sim" ] || parar "Cancelado por você."
fi

# ── 4. Login ──────────────────────────────────────────────────────────────
linha "Conferindo o login na Netlify"
if $NETLIFY status >/dev/null 2>&1; then
  echo "  já logado"
else
  echo "  vai abrir o navegador — clique em Authorize e volte pra cá"
  $NETLIFY login || parar "Não consegui autenticar na Netlify."
fi

# ── 5. Vincular ao projeto ────────────────────────────────────────────────
linha "Vinculando ao projeto $SITE"
if [ -f .netlify/state.json ]; then
  echo "  já vinculado"
else
  $NETLIFY link --name "$SITE" || parar "Não consegui vincular ao projeto $SITE."
fi

# ── 6. Build + deploy ─────────────────────────────────────────────────────
# `--build` roda a esteira completa da Netlify aqui na máquina, com o plugin
# do Next declarado no netlify.toml. Assim o que sobe já vem pronto, e o
# resultado é o mesmo que sairia na nuvem.
linha "Buildando e publicando em produção"
echo "  (demora alguns minutos na primeira vez)"
$NETLIFY deploy --build --prod || parar "O deploy falhou. O erro está acima."

printf '\n\033[1;32m✓ Publicado.\033[0m\n'
echo "  O endereço do site está logo acima, em 'Website URL'."
echo ""
read -r -p "Pressione Enter para fechar."
