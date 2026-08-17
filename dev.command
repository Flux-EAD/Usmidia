#!/bin/bash
# Duplo-clique neste arquivo para subir o site em http://localhost:3000
cd "$(dirname "$0")" || exit 1

# Procura o Node nos lugares mais comuns do macOS, caso não esteja no PATH
for p in /opt/homebrew/bin /usr/local/bin "$HOME/.volta/bin" "$HOME/.nvm/versions/node"/*/bin; do
  [ -x "$p/npm" ] && PATH="$p:$PATH"
done
export PATH

if ! command -v npm >/dev/null 2>&1; then
  echo ""
  echo "  ⚠  Node.js não encontrado neste computador."
  echo ""
  echo "  Instale a versão LTS em https://nodejs.org"
  echo "  (baixe o instalador .pkg para macOS, abra e siga o passo a passo)"
  echo ""
  echo "  Depois é só dar duplo-clique neste arquivo de novo."
  echo ""
  read -r -p "  Pressione Enter para fechar."
  exit 1
fi

if [ ! -d node_modules ]; then
  echo "Instalando dependências..."
  npm install || exit 1
fi

echo ""
echo "  US MÍDIA — servidor de desenvolvimento"
echo "  http://localhost:3000"
echo "  (Ctrl+C para parar)"
echo ""

# abre o navegador só depois que a porta responder
(
  for _ in $(seq 1 60); do
    if curl -s -o /dev/null http://localhost:3000; then
      open http://localhost:3000
      break
    fi
    sleep 1
  done
) &

npm run dev
