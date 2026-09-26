#!/usr/bin/env bash
# Execute no host CachyOS; encerre com Ctrl+C.
url="${1:-http://192.168.122.223/}"
command -v curl >/dev/null || { echo "Instale curl antes de executar." >&2; exit 1; }
while true; do
  date '+%H:%M:%S'
  if curl -fsS --max-time 3 "$url" >/dev/null 2>&1; then
    echo 'OK - site respondeu'
  else
    echo 'ALERTA - site indisponivel'
  fi
  sleep 5
done
