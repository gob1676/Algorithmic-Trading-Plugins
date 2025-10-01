#!/usr/bin/env bash
set -euo pipefail
echo "[GESTEMA-TRADING] Phase 1 setup placeholder"
python3 -m venv .venv || true
source .venv/bin/activate
pip install --upgrade pip
echo "FastAPI and deps will be installed in Phase 2"
