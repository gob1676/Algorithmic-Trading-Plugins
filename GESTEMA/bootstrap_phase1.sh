#!/usr/bin/env bash
set -euo pipefail

ROOT="/workspace/GESTEMA"

echo "[GESTEMA] Phase 1 bootstrap starting in $ROOT"

declare -a DIRS=(
  "$ROOT/GESTEMA-Trading/frontend"
  "$ROOT/GESTEMA-Trading/backend"
  "$ROOT/GESTEMA-Trading/ia_committee"
  "$ROOT/GESTEMA-Trading/brokers"
  "$ROOT/GESTEMA-Trading/plugins"
  "$ROOT/GESTEMA-Trading/docs"
  "$ROOT/GESTEMA-Trading/config"
  "$ROOT/GESTEMA-Trading/data"
  "$ROOT/GESTEMA-Trading/reports"
  "$ROOT/GESTEMA-Trading/backup"
  "$ROOT/GESTEMA-Admin/frontend"
  "$ROOT/GESTEMA-Admin/backend/auth"
  "$ROOT/GESTEMA-Admin/backend/staging"
  "$ROOT/GESTEMA-Admin/backend/updater"
  "$ROOT/GESTEMA-Admin/backend/ia_interpreter"
  "$ROOT/GESTEMA-Admin/backend/ia_evaluator"
  "$ROOT/GESTEMA-Admin/backend/ia_documenter"
  "$ROOT/GESTEMA-Admin/backend/system_monitor"
  "$ROOT/GESTEMA-Admin/backend/logs"
  "$ROOT/GESTEMA-Admin/docs_admin"
  "$ROOT/GESTEMA-Admin/config"
  "$ROOT/global_docs"
)

for d in "${DIRS[@]}"; do
  mkdir -p "$d"
  # ensure VCS-visible even when empty
  touch "$d/.gitkeep"
done

# Root-level README
cat > "$ROOT/README.md" <<'MD'
# GESTEMA Suite (Trading + Admin)

This repository hosts two local-first applications designed for Zorin OS (Ubuntu/Debian):

- GESTEMA Trading: Multi-AI ETF trading platform
- GESTEMA Admin: Administrative companion for safe maintenance, staging, and updates

Phase 1 delivers the directory scaffold and placeholder scripts. Implementation proceeds per phases described in `global_docs/roadmap.md`.
MD

# Roadmap reflecting phased execution
cat > "$ROOT/global_docs/roadmap.md" <<'MD'
# Roadmap por Fases

- Fase 0 – Preparación
- Fase 1 – Crear estructura inicial (Trading + Admin)
- Fase 2 – Backend base Trading (FastAPI)
- Fase 3 – Frontend base Trading (React)
- Fase 4 – Usuarios Trading (bcrypt + JWT + MFA)
- Fase 5 – Módulos Trading Simulado + Prueba Realista
- Fase 6 – Brokers (Alpaca funcional, placeholders otros)
- Fase 7 – Comité Multi‑IA y panel IA
- Fase 8 – Academia Gamificada (XP, escenarios)
- Fase 9 – Sistema de Plugins
- Fase 10 – Backend Admin (login único, auth)
- Fase 11 – Frontend Admin (login + panel control)
- Fase 12 – IA intérprete de cambios (ADMIN)
- Fase 13 – Staging + Gestor de Actualizaciones (ADMIN)
- Fase 14 – Audit logs, rollback, versionado (ADMIN)
- Fase 15 – IA evaluadora + documentadora (ADMIN)
- Fase 16 – Seguridad avanzada + Dockerización + Deploy global
MD

# Minimal setup scripts (placeholders for later phases)
cat > "$ROOT/GESTEMA-Trading/setup.sh" <<'BASH'
#!/usr/bin/env bash
set -euo pipefail
echo "[GESTEMA-TRADING] Phase 1 setup placeholder"
python3 -m venv .venv || true
source .venv/bin/activate
pip install --upgrade pip
echo "FastAPI and deps will be installed in Phase 2"
BASH
chmod +x "$ROOT/GESTEMA-Trading/setup.sh"

cat > "$ROOT/GESTEMA-Admin/setup_admin.sh" <<'BASH'
#!/usr/bin/env bash
set -euo pipefail
echo "[GESTEMA-ADMIN] Phase 1 setup placeholder"
python3 -m venv .venv || true
source .venv/bin/activate
pip install --upgrade pip
echo "Admin backend/frontend deps will be installed in later phases"
BASH
chmod +x "$ROOT/GESTEMA-Admin/setup_admin.sh"

# Config placeholders
cat > "$ROOT/GESTEMA-Trading/config/app.config.yml" <<'YML'
app:
  name: GESTEMA TRADING
  locale_default: es
security:
  data_dir: ../data
  encrypted: true
plugins:
  enabled: []
YML

cat > "$ROOT/GESTEMA-Admin/config/admin.config.yml" <<'YML'
app:
  name: GESTEMA ADMIN
  admin_mfa_required: true
staging:
  enabled: true
  target_path: ../GESTEMA-Trading
YML

# Plugin system skeleton (Trading)
mkdir -p "$ROOT/GESTEMA-Trading/plugins/examples/indicator_rsi"
cat > "$ROOT/GESTEMA-Trading/plugins/README.md" <<'MD'
# Sistema de Plugins

Cada plugin vive en `plugins/<plugin_id>/` y debe incluir `plugin.yml`.

Campos mínimos de `plugin.yml`:

```yaml
name: Nombre legible
id: proveedor.tipo.nombre
version: 0.1.0
type: [indicator|model|broker|dashboard|datasource]
entrypoint: archivo.py
description: Texto
enabled: false
```

El frontend permitirá activar/desactivar plugins más adelante.
MD

cat > "$ROOT/GESTEMA-Trading/plugins/examples/indicator_rsi/plugin.yml" <<'YML'
name: RSI Indicator
id: indicator.rsi
version: 0.1.0
type: indicator
entrypoint: rsi.py
description: Example RSI plugin skeleton.
enabled: false
YML

cat > "$ROOT/GESTEMA-Trading/plugins/examples/indicator_rsi/rsi.py" <<'PY'
def compute_rsi(prices, period=14):
    # Placeholder implementation. Real logic will arrive with the indicators module phase.
    if not prices or len(prices) < period + 1:
        return []
    return [50.0] * len(prices)

if __name__ == "__main__":
    print("RSI plugin skeleton loaded")
PY

# Data encryption helper script (not executed automatically)
cat > "$ROOT/scripts_init_encrypted_storage.sh" <<'BASH'
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
BASH
chmod +x "$ROOT/scripts_init_encrypted_storage.sh"

# Minimal docs placeholders
cat > "$ROOT/GESTEMA-Trading/docs/README.md" <<'MD'
Documentación de GESTEMA Trading. Más contenido en fases posteriores.
MD

cat > "$ROOT/GESTEMA-Admin/docs_admin/README.md" <<'MD'
Documentación de GESTEMA Admin. Más contenido en fases posteriores.
MD

echo "[GESTEMA] Phase 1 bootstrap completed"

