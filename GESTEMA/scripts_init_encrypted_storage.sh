#!/usr/bin/env bash
set -euo pipefail
DATA_DIR="/workspace/GESTEMA/GESTEMA-Trading/data"
MOUNT_DIR="$DATA_DIR.mnt"

if ! command -v gocryptfs >/dev/null 2>&1; then
  echo "gocryptfs no encontrado. Instálalo con: sudo apt update && sudo apt install -y gocryptfs" >&2
  exit 1
fi

mkdir -p "$DATA_DIR" "$MOUNT_DIR"

if [ ! -f "$DATA_DIR/gocryptfs.conf" ]; then
  echo "Inicializando volumen cifrado..."
  gocryptfs -init "$DATA_DIR"
fi

echo "Montando volumen cifrado en $MOUNT_DIR"
gocryptfs "$DATA_DIR" "$MOUNT_DIR"
echo "Usa $MOUNT_DIR para escribir datos; desmonta con: fusermount -u $MOUNT_DIR"
