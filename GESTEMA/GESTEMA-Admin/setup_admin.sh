#!/usr/bin/env bash
set -euo pipefail
echo "[GESTEMA-ADMIN] Phase 1 setup placeholder"
python3 -m venv .venv || true
source .venv/bin/activate
pip install --upgrade pip
echo "Admin backend/frontend deps will be installed in later phases"
