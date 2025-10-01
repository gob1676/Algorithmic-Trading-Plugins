#!/bin/bash

# GESTEMA ADMIN - Script de Instalación Automática
# Compatible con Zorin OS (Ubuntu/Debian)

set -e  # Salir si cualquier comando falla

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Función para imprimir mensajes coloreados
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_admin() {
    echo -e "${PURPLE}[ADMIN]${NC} $1"
}

# Banner de bienvenida
echo -e "${PURPLE}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                     GESTEMA ADMIN                            ║"
echo "║              Instalación Automática v1.0                    ║"
echo "║                                                              ║"
echo "║    Panel de Administración Exclusivo del Sistema            ║"
echo "║    Compatible con Zorin OS (Ubuntu/Debian)                  ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Verificar si se ejecuta como root
if [[ $EUID -eq 0 ]]; then
   print_error "Este script no debe ejecutarse como root"
   exit 1
fi

# Verificar que GESTEMA Trading esté instalado
print_status "Verificando instalación de GESTEMA Trading..."
TRADING_PATH=""

# Buscar GESTEMA Trading en ubicaciones comunes
SEARCH_PATHS=(
    "../GESTEMA-Trading"
    "../../GESTEMA-Trading"
    "/opt/gestema/GESTEMA-Trading"
    "/home/$USER/GESTEMA/GESTEMA-Trading"
    "/usr/local/gestema/GESTEMA-Trading"
)

for path in "${SEARCH_PATHS[@]}"; do
    if [[ -d "$path" && -f "$path/setup.sh" ]]; then
        TRADING_PATH=$(realpath "$path")
        break
    fi
done

if [[ -z "$TRADING_PATH" ]]; then
    print_error "GESTEMA Trading no encontrado"
    echo "Por favor, instale GESTEMA Trading primero o especifique la ruta:"
    read -p "Ruta a GESTEMA Trading: " TRADING_PATH
    
    if [[ ! -d "$TRADING_PATH" ]]; then
        print_error "Ruta no válida: $TRADING_PATH"
        exit 1
    fi
else
    print_success "GESTEMA Trading encontrado en: $TRADING_PATH"
fi

# Verificar sistema operativo
print_status "Verificando sistema operativo..."
if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    if [[ $ID != "ubuntu" && $ID != "zorin" && $ID != "debian" ]]; then
        print_warning "Sistema no oficialmente soportado: $ID"
        read -p "¿Continuar de todos modos? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        print_success "Sistema compatible detectado: $PRETTY_NAME"
    fi
fi

# Verificar recursos del sistema (Admin requiere más recursos)
print_status "Verificando recursos del sistema..."
TOTAL_RAM=$(free -m | awk 'NR==2{printf "%.0f", $2/1024}')
AVAILABLE_SPACE=$(df -BG . | awk 'NR==2{print $4}' | sed 's/G//')

if [[ $TOTAL_RAM -lt 16 ]]; then
    print_warning "RAM disponible: ${TOTAL_RAM}GB (recomendado: 16GB para Admin + Staging)"
else
    print_success "RAM disponible: ${TOTAL_RAM}GB"
fi

if [[ $AVAILABLE_SPACE -lt 40 ]]; then
    print_error "Espacio insuficiente: ${AVAILABLE_SPACE}GB (mínimo requerido: 40GB para Admin + Staging)"
    exit 1
else
    print_success "Espacio disponible: ${AVAILABLE_SPACE}GB"
fi

# Advertencia de seguridad
echo
print_admin "╔════════════════════════════════════════════════════════════════╗"
print_admin "║                    ADVERTENCIA DE SEGURIDAD                    ║"
print_admin "║                                                                ║"
print_admin "║  GESTEMA ADMIN es una aplicación de administración exclusiva  ║"
print_admin "║  con acceso completo al sistema GESTEMA.                      ║"
print_admin "║                                                                ║"
print_admin "║  • Solo debe ser instalada por el administrador del sistema   ║"
print_admin "║  • Requiere autenticación MFA obligatoria                     ║"
print_admin "║  • Todos los accesos son registrados y auditados              ║"
print_admin "║  • Puede modificar y actualizar GESTEMA Trading               ║"
print_admin "║                                                                ║"
print_admin "╚════════════════════════════════════════════════════════════════╝"
echo

read -p "¿Confirma que es el administrador autorizado del sistema? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_error "Instalación cancelada por el usuario"
    exit 1
fi

# Actualizar sistema
print_status "Actualizando sistema..."
sudo apt update && sudo apt upgrade -y

# Instalar dependencias adicionales para Admin
print_status "Instalando dependencias específicas de Admin..."
sudo apt install -y \
    qrencode \
    imagemagick \
    pandoc \
    texlive-latex-base \
    wkhtmltopdf \
    supervisor \
    nginx \
    certbot \
    fail2ban \
    ufw \
    rkhunter \
    chkrootkit

# Crear estructura de directorios Admin
print_status "Creando estructura de directorios Admin..."
mkdir -p backend/{auth,staging,updater,ia_interpreter,ia_evaluator,ia_documenter,system_monitor,logs}
mkdir -p config/secrets
mkdir -p staging_env
mkdir -p data_admin/{users,logs,backups,staging_backups}
mkdir -p reports_admin/{security,performance,changes}

# Configurar permisos estrictos
chmod 700 config/secrets data_admin backend/auth backend/logs
chmod 750 staging_env
chmod 755 reports_admin

print_success "Estructura de directorios Admin creada"

# Configurar entorno virtual Python para Admin
print_status "Configurando entorno virtual Python para Admin..."
cd backend
python3 -m venv venv_admin
source venv_admin/bin/activate

# Crear requirements.txt específico para Admin
cat > requirements_admin.txt << 'EOF'
# GESTEMA ADMIN - Dependencias Python

# Framework web
fastapi==0.104.1
uvicorn[standard]==0.24.0
pydantic==2.5.0
pydantic-settings==2.1.0

# Base de datos
sqlalchemy==2.0.23
alembic==1.13.1
sqlite3

# Autenticación y seguridad
passlib[bcrypt]==1.7.4
python-jose[cryptography]==3.3.0
python-multipart==0.0.6
pyotp==2.9.0
qrcode[pil]==7.4.2
cryptography==41.0.8

# IA y Machine Learning
openai==1.3.7
transformers==4.36.2
torch==2.1.2
scikit-learn==1.3.2
pandas==2.1.4
numpy==1.25.2

# Monitoreo del sistema
psutil==5.9.6
docker==6.1.3
redis==5.0.1

# Procesamiento de archivos
python-docx==1.1.0
openpyxl==3.1.2
reportlab==4.0.7
markdown==3.5.1

# Utilidades
requests==2.31.0
aiofiles==23.2.1
python-dateutil==2.8.2
schedule==1.2.0
watchdog==3.0.0

# Testing
pytest==7.4.3
pytest-asyncio==0.21.1
httpx==0.25.2

# Logging y monitoreo
structlog==23.2.0
prometheus-client==0.19.0
EOF

# Instalar dependencias Python Admin
print_status "Instalando dependencias Python Admin..."
pip install --upgrade pip
pip install -r requirements_admin.txt

print_success "Dependencias Python Admin instaladas"

# Configurar frontend Admin
print_status "Configurando frontend Admin..."
cd ../frontend

# Crear package.json específico para Admin
cat > package.json << 'EOF'
{
  "name": "gestema-admin-frontend",
  "version": "1.0.0",
  "description": "GESTEMA Admin Panel Frontend",
  "private": true,
  "dependencies": {
    "@testing-library/jest-dom": "^5.17.0",
    "@testing-library/react": "^13.4.0",
    "@testing-library/user-event": "^14.5.1",
    "@types/jest": "^27.5.2",
    "@types/node": "^16.18.68",
    "@types/react": "^18.2.42",
    "@types/react-dom": "^18.2.17",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.20.1",
    "react-scripts": "5.0.1",
    "typescript": "^4.9.5",
    "web-vitals": "^2.1.4",
    "@mui/material": "^5.14.20",
    "@mui/icons-material": "^5.14.19",
    "@emotion/react": "^11.11.1",
    "@emotion/styled": "^11.11.0",
    "@mui/x-charts": "^6.18.1",
    "@mui/x-data-grid": "^6.18.1",
    "axios": "^1.6.2",
    "recharts": "^2.8.0",
    "react-query": "^3.39.3",
    "react-hook-form": "^7.48.2",
    "react-hot-toast": "^2.4.1",
    "date-fns": "^2.30.0",
    "lodash": "^4.17.21",
    "qrcode.react": "^3.1.0",
    "react-syntax-highlighter": "^15.5.0"
  },
  "devDependencies": {
    "@types/lodash": "^4.14.202",
    "@types/qrcode.react": "^1.0.5",
    "@types/react-syntax-highlighter": "^15.5.11"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  },
  "eslintConfig": {
    "extends": [
      "react-app",
      "react-app/jest"
    ]
  },
  "browserslist": {
    "production": [
      ">0.2%",
      "not dead",
      "not op_mini all"
    ],
    "development": [
      "last 1 chrome version",
      "last 1 firefox version",
      "last 1 safari version"
    ]
  },
  "proxy": "http://localhost:8001"
}
EOF

npm install

print_success "Dependencias Node.js Admin instaladas"

# Generar configuración Admin
print_status "Generando configuración Admin..."
cd ../config

# Generar claves secretas para Admin
ADMIN_SECRET_KEY=$(python3 -c "import secrets; print(secrets.token_urlsafe(64))")
MFA_SECRET=$(python3 -c "import secrets; print(secrets.token_urlsafe(32))")
ENCRYPTION_KEY=$(python3 -c "import secrets; print(secrets.token_urlsafe(32))")

# Crear archivo de configuración Admin
cat > .env.admin << EOF
# GESTEMA ADMIN - Configuración Exclusiva
ADMIN_DATABASE_URL=sqlite:///./data_admin/admin.db
ADMIN_SECRET_KEY=$ADMIN_SECRET_KEY
ADMIN_MFA_SECRET=$MFA_SECRET
ADMIN_ENCRYPTION_KEY=$ENCRYPTION_KEY

# Configuración de entorno
ENVIRONMENT=production
DEBUG=false
ADMIN_PORT=8001
FRONTEND_PORT=3001

# Configuración de seguridad Admin
JWT_ALGORITHM=HS256
JWT_EXPIRE_MINUTES=15
BCRYPT_ROUNDS=14
MFA_REQUIRED=true
SESSION_TIMEOUT=900
MAX_LOGIN_ATTEMPTS=3
LOCKOUT_DURATION=1800

# Configuración de GESTEMA Trading
TRADING_PATH=$TRADING_PATH
STAGING_PATH=$(pwd)/../staging_env

# Configuración de base de datos Admin
ADMIN_DB_POOL_SIZE=5
ADMIN_DB_MAX_OVERFLOW=10

# Configuración de monitoreo
MONITOR_INTERVAL=30
ALERT_THRESHOLD_CPU=80
ALERT_THRESHOLD_RAM=85
ALERT_THRESHOLD_DISK=90

# Configuración de backup Admin
ADMIN_BACKUP_ENABLED=true
ADMIN_BACKUP_INTERVAL=6
ADMIN_BACKUP_RETENTION_DAYS=90
STAGING_BACKUP_RETENTION_DAYS=7

# Configuración de IAs Admin
AI_INTERPRETER_MODEL=mistral-7b-instruct
AI_EVALUATOR_MODEL=llama2-13b-chat
AI_DOCUMENTER_MODEL=codellama-7b-instruct
AI_MODELS_PATH=../ia_models/

# Configuración de logs Admin
ADMIN_LOG_LEVEL=INFO
ADMIN_LOG_FILE=../backend/logs/admin.log
SECURITY_LOG_FILE=../backend/logs/security.log
AUDIT_LOG_FILE=../backend/logs/audit.log

# Configuración de notificaciones
NOTIFICATIONS_ENABLED=true
EMAIL_NOTIFICATIONS=false
WEBHOOK_NOTIFICATIONS=false

# Configuración de staging
STAGING_AUTO_SYNC=true
STAGING_SYNC_INTERVAL=24
STAGING_TEST_TIMEOUT=300
EOF

# Guardar configuración en archivo seguro
chmod 600 .env.admin

print_success "Configuración Admin generada"

# Configurar base de datos Admin
print_status "Configurando base de datos Admin..."
cd ../backend
source venv_admin/bin/activate

# Crear estructura de base de datos Admin
python3 -c "
import sqlite3
import hashlib
import secrets
from datetime import datetime

# Crear base de datos Admin
conn = sqlite3.connect('../data_admin/admin.db')
cursor = conn.cursor()

# Tabla de usuarios admin (solo uno permitido)
cursor.execute('''
CREATE TABLE IF NOT EXISTS admin_users (
    id INTEGER PRIMARY KEY,
    username TEXT UNIQUE NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    mfa_secret TEXT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    login_attempts INTEGER DEFAULT 0,
    locked_until TIMESTAMP
)
''')

# Tabla de sesiones admin
cursor.execute('''
CREATE TABLE IF NOT EXISTS admin_sessions (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    session_token TEXT UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    ip_address TEXT,
    user_agent TEXT,
    FOREIGN KEY (user_id) REFERENCES admin_users (id)
)
''')

# Tabla de logs de auditoría
cursor.execute('''
CREATE TABLE IF NOT EXISTS audit_logs (
    id INTEGER PRIMARY KEY,
    user_id INTEGER,
    action TEXT NOT NULL,
    resource TEXT,
    details TEXT,
    ip_address TEXT,
    user_agent TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    success BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (user_id) REFERENCES admin_users (id)
)
''')

# Tabla de cambios aplicados
cursor.execute('''
CREATE TABLE IF NOT EXISTS applied_changes (
    id INTEGER PRIMARY KEY,
    change_id TEXT UNIQUE NOT NULL,
    description TEXT NOT NULL,
    target_system TEXT NOT NULL,
    change_type TEXT NOT NULL,
    applied_by INTEGER NOT NULL,
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    rollback_data TEXT,
    status TEXT DEFAULT 'applied',
    FOREIGN KEY (applied_by) REFERENCES admin_users (id)
)
''')

# Tabla de configuración del sistema
cursor.execute('''
CREATE TABLE IF NOT EXISTS system_config (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL,
    description TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by INTEGER,
    FOREIGN KEY (updated_by) REFERENCES admin_users (id)
)
''')

conn.commit()
conn.close()
print('Base de datos Admin inicializada')
"

print_success "Base de datos Admin configurada"

# Configurar entorno staging
print_status "Configurando entorno staging..."
cd ../staging_env

# Crear script de sincronización con Trading
cat > sync_trading.sh << 'EOF'
#!/bin/bash

TRADING_PATH="$1"
STAGING_PATH="$(pwd)"

if [[ -z "$TRADING_PATH" ]]; then
    echo "Error: Ruta de GESTEMA Trading no especificada"
    exit 1
fi

echo "Sincronizando GESTEMA Trading a staging..."
echo "Origen: $TRADING_PATH"
echo "Destino: $STAGING_PATH"

# Crear backup del staging actual
if [[ -d "GESTEMA-Trading" ]]; then
    mv GESTEMA-Trading "GESTEMA-Trading.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Copiar Trading a staging
cp -r "$TRADING_PATH" ./GESTEMA-Trading

# Modificar configuración para staging
cd GESTEMA-Trading/config
if [[ -f ".env" ]]; then
    sed -i 's/ENVIRONMENT=production/ENVIRONMENT=staging/' .env
    sed -i 's/DEBUG=false/DEBUG=true/' .env
    sed -i 's/8000/8002/' .env  # Puerto diferente para staging
fi

echo "Sincronización completada"
EOF

chmod +x sync_trading.sh

# Ejecutar sincronización inicial
./sync_trading.sh "$TRADING_PATH"

print_success "Entorno staging configurado"

# Crear usuario administrador
print_status "Configurando usuario administrador..."

echo
print_admin "Configuración del Usuario Administrador"
echo "========================================"

# Solicitar datos del administrador
read -p "Nombre de usuario admin: " ADMIN_USERNAME
read -p "Email del administrador: " ADMIN_EMAIL

# Generar contraseña temporal segura
TEMP_PASSWORD=$(python3 -c "import secrets, string; print(''.join(secrets.choice(string.ascii_letters + string.digits + '!@#$%^&*') for _ in range(16)))")

echo "Contraseña temporal generada: $TEMP_PASSWORD"
echo "IMPORTANTE: Guarde esta contraseña, deberá cambiarla en el primer login"

# Crear usuario en base de datos
cd ../backend
source venv_admin/bin/activate

python3 -c "
import sqlite3
import bcrypt
import pyotp
import qrcode
from io import BytesIO
import base64

# Conectar a base de datos
conn = sqlite3.connect('../data_admin/admin.db')
cursor = conn.cursor()

# Datos del usuario
username = '$ADMIN_USERNAME'
email = '$ADMIN_EMAIL'
password = '$TEMP_PASSWORD'

# Hash de contraseña
password_hash = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')

# Generar secreto MFA
mfa_secret = pyotp.random_base32()

# Insertar usuario
try:
    cursor.execute('''
        INSERT INTO admin_users (username, email, password_hash, mfa_secret)
        VALUES (?, ?, ?, ?)
    ''', (username, email, password_hash, mfa_secret))
    
    conn.commit()
    
    # Generar QR para MFA
    totp_uri = pyotp.totp.TOTP(mfa_secret).provisioning_uri(
        name=email,
        issuer_name='GESTEMA Admin'
    )
    
    qr = qrcode.QRCode(version=1, box_size=10, border=5)
    qr.add_data(totp_uri)
    qr.make(fit=True)
    
    # Guardar QR como imagen
    img = qr.make_image(fill_color='black', back_color='white')
    img.save('../config/mfa_qr.png')
    
    print(f'Usuario administrador creado: {username}')
    print(f'Secreto MFA: {mfa_secret}')
    print('QR Code guardado en: config/mfa_qr.png')
    
except Exception as e:
    print(f'Error creando usuario admin: {e}')

conn.close()
"

print_success "Usuario administrador configurado"

# Configurar servicios de monitoreo
print_status "Configurando servicios de monitoreo..."

# Crear script de monitoreo del sistema
cat > system_monitor.py << 'EOF'
#!/usr/bin/env python3

import psutil
import time
import json
import sqlite3
from datetime import datetime

def get_system_metrics():
    return {
        'timestamp': datetime.now().isoformat(),
        'cpu_percent': psutil.cpu_percent(interval=1),
        'memory_percent': psutil.virtual_memory().percent,
        'disk_percent': psutil.disk_usage('/').percent,
        'network_io': psutil.net_io_counters()._asdict(),
        'processes': len(psutil.pids()),
        'load_average': psutil.getloadavg() if hasattr(psutil, 'getloadavg') else [0, 0, 0]
    }

def save_metrics(metrics):
    conn = sqlite3.connect('../data_admin/admin.db')
    cursor = conn.cursor()
    
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS system_metrics (
            id INTEGER PRIMARY KEY,
            timestamp TIMESTAMP,
            cpu_percent REAL,
            memory_percent REAL,
            disk_percent REAL,
            network_bytes_sent INTEGER,
            network_bytes_recv INTEGER,
            processes INTEGER,
            load_avg_1m REAL,
            load_avg_5m REAL,
            load_avg_15m REAL
        )
    ''')
    
    cursor.execute('''
        INSERT INTO system_metrics 
        (timestamp, cpu_percent, memory_percent, disk_percent, 
         network_bytes_sent, network_bytes_recv, processes,
         load_avg_1m, load_avg_5m, load_avg_15m)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ''', (
        metrics['timestamp'],
        metrics['cpu_percent'],
        metrics['memory_percent'],
        metrics['disk_percent'],
        metrics['network_io']['bytes_sent'],
        metrics['network_io']['bytes_recv'],
        metrics['processes'],
        metrics['load_average'][0],
        metrics['load_average'][1],
        metrics['load_average'][2]
    ))
    
    conn.commit()
    conn.close()

if __name__ == '__main__':
    while True:
        try:
            metrics = get_system_metrics()
            save_metrics(metrics)
            print(f"Métricas guardadas: {metrics['timestamp']}")
            time.sleep(30)  # Cada 30 segundos
        except KeyboardInterrupt:
            print("Monitor detenido")
            break
        except Exception as e:
            print(f"Error en monitoreo: {e}")
            time.sleep(60)
EOF

chmod +x system_monitor.py

# Crear servicio systemd para Admin
print_status "¿Desea configurar GESTEMA Admin como servicio del sistema? (y/N)"
read -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "Configurando servicio systemd para Admin..."
    
    sudo tee /etc/systemd/system/gestema-admin.service > /dev/null << EOF
[Unit]
Description=GESTEMA Admin Panel
After=network.target
Requires=gestema-trading.service

[Service]
Type=simple
User=$USER
WorkingDirectory=$(pwd)
Environment=PATH=$(pwd)/venv_admin/bin
ExecStart=$(pwd)/venv_admin/bin/python -m uvicorn app.main:app --host 127.0.0.1 --port 8001
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

    # Servicio de monitoreo
    sudo tee /etc/systemd/system/gestema-monitor.service > /dev/null << EOF
[Unit]
Description=GESTEMA System Monitor
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$(pwd)
Environment=PATH=$(pwd)/venv_admin/bin
ExecStart=$(pwd)/venv_admin/bin/python system_monitor.py
Restart=always
RestartSec=30
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl daemon-reload
    sudo systemctl enable gestema-admin
    sudo systemctl enable gestema-monitor
    print_success "Servicios systemd configurados"
fi

# Configurar firewall básico
print_status "Configurando firewall básico..."
sudo ufw --force enable
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 8001/tcp comment 'GESTEMA Admin'
sudo ufw allow 3001/tcp comment 'GESTEMA Admin Frontend'

print_success "Firewall configurado"

# Crear scripts de utilidad Admin
print_status "Creando scripts de utilidad Admin..."

# Script de inicio Admin
cat > start_admin.sh << 'EOF'
#!/bin/bash
echo "Iniciando GESTEMA Admin..."

# Verificar que Trading esté ejecutándose
if ! pgrep -f "uvicorn.*app.main:app.*8000" > /dev/null; then
    echo "ADVERTENCIA: GESTEMA Trading no está ejecutándose"
    echo "Inicie GESTEMA Trading primero"
fi

# Iniciar monitor del sistema
cd backend
source venv_admin/bin/activate
python system_monitor.py &
MONITOR_PID=$!

# Iniciar backend Admin
python -m uvicorn app.main:app --host 127.0.0.1 --port 8001 --reload &
BACKEND_PID=$!

# Iniciar frontend Admin
cd ../frontend
npm start &
FRONTEND_PID=$!

echo "Monitor PID: $MONITOR_PID"
echo "Backend Admin PID: $BACKEND_PID"
echo "Frontend Admin PID: $FRONTEND_PID"
echo "GESTEMA Admin iniciado correctamente"
echo "Panel Admin: http://localhost:3001"
echo "API Admin: http://localhost:8001"
echo "Presiona Ctrl+C para detener"

# Función para limpiar procesos al salir
cleanup() {
    echo "Deteniendo GESTEMA Admin..."
    kill $MONITOR_PID $BACKEND_PID $FRONTEND_PID 2>/dev/null
    exit 0
}

trap cleanup SIGINT SIGTERM

wait
EOF

chmod +x start_admin.sh

# Script de parada Admin
cat > stop_admin.sh << 'EOF'
#!/bin/bash
echo "Deteniendo GESTEMA Admin..."
pkill -f "uvicorn.*app.main:app.*8001"
pkill -f "npm start.*3001"
pkill -f "python system_monitor.py"
echo "GESTEMA Admin detenido"
EOF

chmod +x stop_admin.sh

# Script de backup Admin
cat > backup_admin.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="../data_admin/backups/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "Creando backup Admin en $BACKUP_DIR..."

# Backup de base de datos Admin
cp ../data_admin/admin.db "$BACKUP_DIR/" 2>/dev/null || echo "No se encontró base de datos Admin"

# Backup de configuración Admin
cp -r ../config "$BACKUP_DIR/"

# Backup de logs
cp -r logs "$BACKUP_DIR/" 2>/dev/null || echo "No se encontraron logs"

# Backup de staging
if [[ -d "../staging_env/GESTEMA-Trading" ]]; then
    tar -czf "$BACKUP_DIR/staging_backup.tar.gz" -C ../staging_env GESTEMA-Trading
fi

# Crear archivo de información
cat > "$BACKUP_DIR/backup_info.txt" << EOL
Backup Admin creado: $(date)
Versión: $(git describe --tags 2>/dev/null || echo "unknown")
Sistema: $(uname -a)
Usuario: $(whoami)
EOL

echo "Backup Admin completado en $BACKUP_DIR"
EOF

chmod +x backup_admin.sh

# Script de sincronización staging
cat > sync_staging.sh << 'EOF'
#!/bin/bash
echo "Sincronizando staging con producción..."

# Cargar configuración
source ../config/.env.admin

# Ejecutar sincronización
cd ../staging_env
./sync_trading.sh "$TRADING_PATH"

echo "Staging sincronizado correctamente"
EOF

chmod +x sync_staging.sh

print_success "Scripts de utilidad Admin creados"

# Verificar instalación Admin
print_status "Verificando instalación Admin..."

# Verificar backend Admin
source venv_admin/bin/activate
python3 -c "
try:
    import fastapi
    import sqlalchemy
    import bcrypt
    import pyotp
    print('✓ Backend Admin: Dependencias OK')
except Exception as e:
    print(f'✗ Backend Admin: Error - {e}')
"

# Verificar frontend Admin
cd ../frontend
if npm run build > /dev/null 2>&1; then
    print_success "✓ Frontend Admin: OK"
else
    print_error "✗ Frontend Admin: Error en build"
fi

# Mostrar información de MFA
echo
print_admin "╔══════════════════════════════════════════════════════════════╗"
print_admin "║                CONFIGURACIÓN MFA REQUERIDA                   ║"
print_admin "╚══════════════════════════════════════════════════════════════╝"
echo
print_admin "1. Instale una app de autenticación (Google Authenticator, Authy, etc.)"
print_admin "2. Escanee el código QR en: config/mfa_qr.png"
print_admin "3. O ingrese manualmente el secreto mostrado arriba"
print_admin "4. El MFA es OBLIGATORIO para acceder al panel Admin"

# Mostrar resumen final
echo
echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║              INSTALACIÓN ADMIN COMPLETADA                   ║${NC}"
echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo
print_success "GESTEMA Admin instalado correctamente"
echo
echo -e "${BLUE}Credenciales de Administrador:${NC}"
echo "• Usuario: $ADMIN_USERNAME"
echo "• Email: $ADMIN_EMAIL"
echo "• Contraseña temporal: $TEMP_PASSWORD"
echo "• MFA: Configurar con QR en config/mfa_qr.png"
echo
echo -e "${BLUE}Próximos pasos:${NC}"
echo "1. Configurar MFA con la app de autenticación"
echo "2. Cambiar contraseña temporal en primer login"
echo "3. Ejecutar: ./start_admin.sh para iniciar Admin"
echo "4. Acceder a: http://localhost:3001"
echo "5. Verificar que GESTEMA Trading esté ejecutándose"
echo
echo -e "${BLUE}Comandos útiles Admin:${NC}"
echo "• Iniciar Admin: ./start_admin.sh"
echo "• Detener Admin: ./stop_admin.sh"
echo "• Backup Admin: ./backup_admin.sh"
echo "• Sincronizar Staging: ./sync_staging.sh"
echo "• Logs Admin: tail -f logs/admin.log"
echo "• Logs Seguridad: tail -f logs/security.log"
echo
echo -e "${YELLOW}IMPORTANTE - SEGURIDAD:${NC}"
echo "• Cambiar contraseña temporal INMEDIATAMENTE"
echo "• Configurar MFA antes del primer uso"
echo "• Revisar logs de seguridad regularmente"
echo "• Mantener backups actualizados"
echo "• Solo acceder desde IPs autorizadas"
echo
echo -e "${RED}ADVERTENCIAS:${NC}"
echo "• GESTEMA Admin tiene acceso completo al sistema"
echo "• Todos los accesos son registrados y auditados"
echo "• No compartir credenciales de administrador"
echo "• Usar solo para administración autorizada"
echo
print_success "¡GESTEMA Admin listo para administrar el sistema! 🔐"