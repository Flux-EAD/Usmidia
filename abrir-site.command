#!/bin/bash
# Duplo-clique para abrir/recarregar o site no navegador.
# Requer o servidor rodando (dev.command).
if curl -s -o /dev/null --max-time 3 http://localhost:3000; then
  open "http://localhost:3000/?r=$(date +%s)"
else
  echo ""
  echo "  O servidor não está rodando."
  echo "  Abra o dev.command primeiro."
  echo ""
  read -r -p "  Pressione Enter para fechar."
fi
