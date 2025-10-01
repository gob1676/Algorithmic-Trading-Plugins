#!/bin/bash

# GESTEMA TRADING - Script de Instalación Automática
# Compatible con Zorin OS (Ubuntu/Debian)

set -e  # Salir si cualquier comando falla

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

# Banner de bienvenida
echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                    GESTEMA TRADING                           ║"
echo "║              Instalación Automática v1.0                    ║"
echo "║                                                              ║"
echo "║  Plataforma de Trading Inteligente con Multi-IA             ║"
echo "║  Compatible con Zorin OS (Ubuntu/Debian)                    ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Verificar si se ejecuta como root
if [[ $EUID -eq 0 ]]; then
   print_error "Este script no debe ejecutarse como root"
   exit 1
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
else
    print_error "No se pudo detectar el sistema operativo"
    exit 1
fi

# Verificar recursos del sistema
print_status "Verificando recursos del sistema..."
TOTAL_RAM=$(free -m | awk 'NR==2{printf "%.0f", $2/1024}')
AVAILABLE_SPACE=$(df -BG . | awk 'NR==2{print $4}' | sed 's/G//')

if [[ $TOTAL_RAM -lt 8 ]]; then
    print_warning "RAM disponible: ${TOTAL_RAM}GB (mínimo recomendado: 8GB)"
else
    print_success "RAM disponible: ${TOTAL_RAM}GB"
fi

if [[ $AVAILABLE_SPACE -lt 20 ]]; then
    print_error "Espacio insuficiente: ${AVAILABLE_SPACE}GB (mínimo requerido: 20GB)"
    exit 1
else
    print_success "Espacio disponible: ${AVAILABLE_SPACE}GB"
fi

# Actualizar sistema
print_status "Actualizando sistema..."
sudo apt update && sudo apt upgrade -y

# Instalar dependencias del sistema
print_status "Instalando dependencias del sistema..."
sudo apt install -y \
    curl \
    wget \
    git \
    build-essential \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    python3 \
    python3-pip \
    python3-venv \
    nodejs \
    npm \
    sqlite3 \
    postgresql-client \
    redis-tools \
    htop \
    tree \
    jq

# Verificar versiones
print_status "Verificando versiones de herramientas..."
PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
NODE_VERSION=$(node --version | cut -d'v' -f2)

print_success "Python: $PYTHON_VERSION"
print_success "Node.js: $NODE_VERSION"

# Verificar versión mínima de Python
if [[ $(echo "$PYTHON_VERSION" | cut -d'.' -f1,2) < "3.9" ]]; then
    print_error "Python 3.9+ requerido, encontrado: $PYTHON_VERSION"
    exit 1
fi

# Instalar Docker
print_status "Instalando Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo usermod -aG docker $USER
    print_success "Docker instalado correctamente"
else
    print_success "Docker ya está instalado"
fi

# Instalar Docker Compose
print_status "Instalando Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    print_success "Docker Compose instalado correctamente"
else
    print_success "Docker Compose ya está instalado"
fi

# Crear directorios necesarios
print_status "Creando estructura de directorios..."
mkdir -p data/{users,portfolios,transactions,market_data}
mkdir -p reports/{pdf,excel,templates}
mkdir -p backup/{daily,weekly,monthly}
mkdir -p config/secrets
mkdir -p logs

# Configurar permisos
chmod 700 data config/secrets
chmod 755 reports backup logs

print_success "Estructura de directorios creada"

# Configurar entorno virtual Python
print_status "Configurando entorno virtual Python..."
cd backend
python3 -m venv venv
source venv/bin/activate

# Instalar dependencias Python
print_status "Instalando dependencias Python..."
pip install --upgrade pip
pip install -r requirements.txt

print_success "Dependencias Python instaladas"

# Configurar frontend
print_status "Configurando frontend..."
cd ../frontend
npm install

print_success "Dependencias Node.js instaladas"

# Generar configuración inicial
print_status "Generando configuración inicial..."
cd ../config

# Generar clave secreta
SECRET_KEY=$(python3 -c "import secrets; print(secrets.token_urlsafe(32))")

# Crear archivo de configuración
cat > .env << EOF
# GESTEMA TRADING - Configuración
DATABASE_URL=sqlite:///./data/gestema.db
SECRET_KEY=$SECRET_KEY
ENVIRONMENT=development
DEBUG=true

# Configuración de seguridad
JWT_ALGORITHM=HS256
JWT_EXPIRE_MINUTES=30
BCRYPT_ROUNDS=12

# Configuración de base de datos
DB_POOL_SIZE=10
DB_MAX_OVERFLOW=20

# Configuración de Redis (para caché)
REDIS_URL=redis://localhost:6379/0

# Configuración de brokers (completar después)
ALPACA_API_KEY=
ALPACA_SECRET_KEY=
ALPACA_BASE_URL=https://paper-api.alpaca.markets

# Configuración de IAs
AI_MODEL_PATH=../ia_committee/models/
ENABLE_GPU=false

# Configuración de logs
LOG_LEVEL=INFO
LOG_FILE=../logs/gestema.log

# Configuración de backup
BACKUP_ENABLED=true
BACKUP_INTERVAL=24
BACKUP_RETENTION_DAYS=30
EOF

print_success "Configuración inicial generada"

# Configurar base de datos
print_status "Configurando base de datos..."
cd ../backend
source venv/bin/activate

# Crear base de datos y tablas
python -c "
from app.core.database import engine, Base
from app.models import *
Base.metadata.create_all(bind=engine)
print('Base de datos inicializada')
"

print_success "Base de datos configurada"

# Crear usuario administrador por defecto
print_status "Creando usuario administrador por defecto..."
python -c "
from app.services.user_service import UserService
from app.core.database import get_db
from app.models.user import UserCreate

db = next(get_db())
user_service = UserService(db)

admin_user = UserCreate(
    username='admin',
    email='admin@gestema.local',
    password='admin123',
    is_admin=True
)

try:
    user = user_service.create_user(admin_user)
    print(f'Usuario administrador creado: {user.username}')
    print('IMPORTANTE: Cambiar contraseña por defecto después del primer login')
except Exception as e:
    print(f'Error creando usuario admin: {e}')
"

# Configurar servicios systemd (opcional)
print_status "¿Desea configurar GESTEMA como servicio del sistema? (y/N)"
read -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "Configurando servicio systemd..."
    
    sudo tee /etc/systemd/system/gestema-trading.service > /dev/null << EOF
[Unit]
Description=GESTEMA Trading Platform
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$(pwd)
Environment=PATH=$(pwd)/backend/venv/bin
ExecStart=$(pwd)/backend/venv/bin/python -m uvicorn app.main:app --host 0.0.0.0 --port 8000
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl daemon-reload
    sudo systemctl enable gestema-trading
    print_success "Servicio systemd configurado"
fi

# Crear scripts de utilidad
print_status "Creando scripts de utilidad..."

# Script de inicio
cat > start.sh << 'EOF'
#!/bin/bash
echo "Iniciando GESTEMA Trading..."

# Iniciar backend
cd backend
source venv/bin/activate
python -m uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload &
BACKEND_PID=$!

# Iniciar frontend
cd ../frontend
npm start &
FRONTEND_PID=$!

echo "Backend PID: $BACKEND_PID"
echo "Frontend PID: $FRONTEND_PID"
echo "GESTEMA Trading iniciado correctamente"
echo "Backend: http://localhost:8000"
echo "Frontend: http://localhost:3000"
echo "Presiona Ctrl+C para detener"

# Función para limpiar procesos al salir
cleanup() {
    echo "Deteniendo GESTEMA Trading..."
    kill $BACKEND_PID $FRONTEND_PID 2>/dev/null
    exit 0
}

trap cleanup SIGINT SIGTERM

wait
EOF

chmod +x start.sh

# Script de parada
cat > stop.sh << 'EOF'
#!/bin/bash
echo "Deteniendo GESTEMA Trading..."
pkill -f "uvicorn app.main:app"
pkill -f "npm start"
echo "GESTEMA Trading detenido"
EOF

chmod +x stop.sh

# Script de backup
cat > backup.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="backup/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "Creando backup en $BACKUP_DIR..."

# Backup de base de datos
cp data/gestema.db "$BACKUP_DIR/" 2>/dev/null || echo "No se encontró base de datos"

# Backup de configuración
cp -r config "$BACKUP_DIR/"

# Backup de datos de usuario
cp -r data "$BACKUP_DIR/"

# Crear archivo de información
cat > "$BACKUP_DIR/backup_info.txt" << EOL
Backup creado: $(date)
Versión: $(git describe --tags 2>/dev/null || echo "unknown")
Sistema: $(uname -a)
EOL

echo "Backup completado en $BACKUP_DIR"
EOF

chmod +x backup.sh

print_success "Scripts de utilidad creados"

# Verificar instalación
print_status "Verificando instalación..."

# Verificar backend
cd backend
source venv/bin/activate
python -c "
try:
    from app.main import app
    print('✓ Backend: OK')
except Exception as e:
    print(f'✗ Backend: Error - {e}')
"

# Verificar frontend
cd ../frontend
if npm run build > /dev/null 2>&1; then
    print_success "✓ Frontend: OK"
else
    print_error "✗ Frontend: Error en build"
fi

# Mostrar resumen final
echo
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                 INSTALACIÓN COMPLETADA                      ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo
print_success "GESTEMA Trading instalado correctamente"
echo
echo -e "${BLUE}Próximos pasos:${NC}"
echo "1. Configurar API keys de brokers en config/.env"
echo "2. Cambiar contraseña del usuario admin (admin/admin123)"
echo "3. Ejecutar: ./start.sh para iniciar la aplicación"
echo "4. Acceder a: http://localhost:3000"
echo
echo -e "${BLUE}Comandos útiles:${NC}"
echo "• Iniciar: ./start.sh"
echo "• Detener: ./stop.sh"
echo "• Backup: ./backup.sh"
echo "• Logs: tail -f logs/gestema.log"
echo
echo -e "${YELLOW}IMPORTANTE:${NC}"
echo "• Cambiar contraseñas por defecto"
echo "• Configurar MFA para mayor seguridad"
echo "• Revisar configuración en config/.env"
echo "• Leer documentación en docs/"
echo
print_success "¡Disfruta usando GESTEMA Trading! 🚀"