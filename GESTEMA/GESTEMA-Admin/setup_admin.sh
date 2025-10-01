#!/bin/bash

# GESTEMA ADMIN - Script de Configuración Inicial
# Para Zorin OS (Ubuntu/Debian)

set -e

echo "🔧 Iniciando configuración de GESTEMA ADMIN..."

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Función para imprimir mensajes
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

# Verificar sistema operativo
check_os() {
    print_status "Verificando sistema operativo..."
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt &> /dev/null; then
            OS="ubuntu"
            print_success "Sistema Ubuntu/Debian detectado"
        else
            print_error "Sistema no soportado. Se requiere Ubuntu/Debian"
            exit 1
        fi
    else
        print_error "Sistema operativo no soportado. Se requiere Linux"
        exit 1
    fi
}

# Verificar instalación de GESTEMA TRADING
check_gestema_trading() {
    print_status "Buscando instalación de GESTEMA TRADING..."
    
    SEARCH_PATHS=(
        "/opt/gestema/GESTEMA-Trading"
        "/home/$USER/gestema/GESTEMA-Trading"
        "/workspace/gestema/GESTEMA-Trading"
        "/usr/local/gestema/GESTEMA-Trading"
        "$(pwd)/../GESTEMA-Trading"
    )
    
    GESTEMA_TRADING_PATH=""
    
    for path in "${SEARCH_PATHS[@]}"; do
        if [ -d "$path" ] && [ -f "$path/setup.sh" ]; then
            GESTEMA_TRADING_PATH="$path"
            print_success "GESTEMA TRADING encontrado en: $path"
            break
        fi
    done
    
    if [ -z "$GESTEMA_TRADING_PATH" ]; then
        print_warning "GESTEMA TRADING no encontrado automáticamente"
        read -p "Ingrese la ruta completa a GESTEMA TRADING: " GESTEMA_TRADING_PATH
        
        if [ ! -d "$GESTEMA_TRADING_PATH" ]; then
            print_error "Ruta no válida: $GESTEMA_TRADING_PATH"
            exit 1
        fi
    fi
    
    # Guardar ruta en configuración
    echo "GESTEMA_TRADING_PATH=$GESTEMA_TRADING_PATH" >> .env
}

# Instalar dependencias del sistema
install_system_dependencies() {
    print_status "Instalando dependencias del sistema..."
    
    sudo apt update
    sudo apt install -y \
        python3.11 \
        python3.11-venv \
        python3.11-dev \
        python3-pip \
        nodejs \
        npm \
        postgresql \
        postgresql-contrib \
        redis-server \
        git \
        curl \
        wget \
        build-essential \
        libssl-dev \
        libffi-dev \
        libpq-dev \
        pkg-config \
        docker.io \
        docker-compose \
        htop \
        iotop \
        nethogs \
        jq \
        yq
    
    # Agregar usuario al grupo docker
    sudo usermod -aG docker $USER
    
    print_success "Dependencias del sistema instaladas"
}

# Configurar PostgreSQL para Admin
setup_postgresql() {
    print_status "Configurando PostgreSQL para GESTEMA ADMIN..."
    
    sudo systemctl start postgresql
    sudo systemctl enable postgresql
    
    # Crear usuario y base de datos para admin
    sudo -u postgres psql -c "CREATE USER gestema_admin WITH PASSWORD 'admin123';"
    sudo -u postgres psql -c "CREATE DATABASE gestema_admin OWNER gestema_admin;"
    sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE gestema_admin TO gestema_admin;"
    
    print_success "PostgreSQL configurado para ADMIN"
}

# Configurar Redis para Admin
setup_redis() {
    print_status "Configurando Redis para GESTEMA ADMIN..."
    
    sudo systemctl start redis-server
    sudo systemctl enable redis-server
    
    # Configurar Redis para admin (base de datos 1)
    sudo sed -i 's/^# save 900 1/save 900 1/' /etc/redis/redis.conf
    sudo sed -i 's/^# save 300 10/save 300 10/' /etc/redis/redis.conf
    sudo sed -i 's/^# save 60 10000/save 60 10000/' /etc/redis/redis.conf
    
    sudo systemctl restart redis-server
    
    print_success "Redis configurado para ADMIN"
}

# Configurar entorno Python
setup_python_env() {
    print_status "Configurando entorno Python para ADMIN..."
    
    cd backend
    
    # Crear entorno virtual
    python3.11 -m venv venv
    source venv/bin/activate
    
    # Actualizar pip
    pip install --upgrade pip setuptools wheel
    
    # Instalar dependencias específicas para admin
    cat > requirements.txt << EOF
fastapi==0.104.1
uvicorn[standard]==0.24.0
sqlalchemy==2.0.23
alembic==1.12.1
psycopg2-binary==2.9.9
redis==5.0.1
celery==5.3.4
pydantic==2.5.0
pydantic-settings==2.1.0
python-jose[cryptography]==3.3.0
passlib[argon2]==1.7.4
python-multipart==0.0.6
pyyaml==6.0.1
docker==6.1.3
psutil==5.9.6
schedule==1.2.0
cryptography==41.0.8
argon2-cffi==23.1.0
qrcode[pil]==7.4.2
pyotp==2.9.0
httpx==0.25.2
aiofiles==23.2.1
jinja2==3.1.2
watchdog==3.0.0
gitpython==3.1.40
transformers==4.36.2
torch==2.1.1
accelerate==0.25.0
sentencepiece==0.1.99
protobuf==4.25.1
EOF
    
    pip install -r requirements.txt
    
    deactivate
    cd ..
    
    print_success "Entorno Python configurado para ADMIN"
}

# Configurar entorno Node.js
setup_node_env() {
    print_status "Configurando entorno Node.js para ADMIN..."
    
    cd frontend
    
    # Crear package.json para admin
    cat > package.json << EOF
{
  "name": "gestema-admin-frontend",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "lint": "eslint . --ext js,jsx,ts,tsx",
    "type-check": "tsc --noEmit"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.20.1",
    "@tanstack/react-query": "^5.8.4",
    "axios": "^1.6.2",
    "framer-motion": "^10.16.16",
    "lucide-react": "^0.294.0",
    "recharts": "^2.8.0",
    "react-hook-form": "^7.48.2",
    "zod": "^3.22.4",
    "@hookform/resolvers": "^3.3.2",
    "react-hot-toast": "^2.4.1",
    "date-fns": "^2.30.0",
    "clsx": "^2.0.0",
    "tailwind-merge": "^2.0.0",
    "react-terminal-ui": "^1.0.0",
    "react-syntax-highlighter": "^15.5.0",
    "monaco-editor": "^0.45.0",
    "@monaco-editor/react": "^4.6.0"
  },
  "devDependencies": {
    "@types/react": "^18.2.37",
    "@types/react-dom": "^18.2.15",
    "@typescript-eslint/eslint-plugin": "^6.10.0",
    "@typescript-eslint/parser": "^6.10.0",
    "@vitejs/plugin-react": "^4.1.1",
    "autoprefixer": "^10.4.16",
    "eslint": "^8.53.0",
    "eslint-plugin-react-hooks": "^4.6.0",
    "eslint-plugin-react-refresh": "^0.4.4",
    "postcss": "^8.4.31",
    "tailwindcss": "^3.3.5",
    "typescript": "^5.2.2",
    "vite": "^5.0.0"
  }
}
EOF
    
    # Instalar dependencias
    npm install
    
    cd ..
    
    print_success "Entorno Node.js configurado para ADMIN"
}

# Crear directorios necesarios
create_directories() {
    print_status "Creando directorios necesarios para ADMIN..."
    
    mkdir -p logs
    mkdir -p staging
    mkdir -p backup
    mkdir -p vault
    mkdir -p temp
    
    # Establecer permisos
    chmod 700 logs staging backup vault temp
    
    print_success "Directorios creados"
}

# Configurar variables de entorno
setup_environment() {
    print_status "Configurando variables de entorno para ADMIN..."
    
    cat > .env << EOF
# GESTEMA ADMIN - Variables de Entorno
ENVIRONMENT=development
DEBUG=true
SECRET_KEY=admin-secret-key-change-in-production-$(openssl rand -hex 32)
DATABASE_URL=postgresql://gestema_admin:admin123@localhost:5432/gestema_admin
REDIS_URL=redis://localhost:6379/1
ENCRYPTION_KEY=$(openssl rand -hex 32)

# Configuración de staging
STAGING_DIRECTORY=./staging
STAGING_CLEANUP_HOURS=24
MAX_STAGING_INSTANCES=3

# IA Models para admin
HUGGINGFACE_API_TOKEN=
OPENAI_API_KEY=
MODEL_NAME=qwen2.5-7b-instruct

# Monitoreo
MONITOR_INTERVAL_SECONDS=30
ALERT_CPU_THRESHOLD=80
ALERT_MEMORY_THRESHOLD=85
ALERT_DISK_THRESHOLD=90

# Logging
LOG_LEVEL=INFO
LOG_FILE=./logs/gestema_admin.log
AUDIT_LOG_FILE=./logs/admin_audit.log

# Seguridad
MFA_REQUIRED=true
SESSION_TIMEOUT_MINUTES=30
MAX_LOGIN_ATTEMPTS=3
LOCKOUT_DURATION_MINUTES=15
EOF
    
    chmod 600 .env
    
    print_success "Variables de entorno configuradas"
}

# Crear administrador inicial
create_admin_user() {
    print_admin "Creando administrador inicial..."
    
    cd backend
    source venv/bin/activate
    
    # Crear script para administrador
    cat > create_admin.py << 'EOF'
import asyncio
import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker
from passlib.context import CryptContext
from datetime import datetime
import pyotp
import qrcode
from io import BytesIO
import base64

# Configuración
DATABASE_URL = "postgresql://gestema_admin:admin123@localhost:5432/gestema_admin"
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

pwd_context = CryptContext(schemes=["argon2"], deprecated="auto")

def create_tables():
    """Crear tablas administrativas"""
    with engine.connect() as conn:
        # Tabla de administradores
        conn.execute(text("""
            CREATE TABLE IF NOT EXISTS admins (
                id SERIAL PRIMARY KEY,
                username VARCHAR(50) UNIQUE NOT NULL,
                email VARCHAR(100) UNIQUE NOT NULL,
                hashed_password VARCHAR(255) NOT NULL,
                full_name VARCHAR(100),
                is_active BOOLEAN DEFAULT TRUE,
                mfa_secret VARCHAR(32),
                mfa_enabled BOOLEAN DEFAULT FALSE,
                last_login TIMESTAMP,
                login_attempts INTEGER DEFAULT 0,
                locked_until TIMESTAMP,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        """))
        
        # Tabla de cambios
        conn.execute(text("""
            CREATE TABLE IF NOT EXISTS changes (
                id SERIAL PRIMARY KEY,
                admin_id INTEGER REFERENCES admins(id),
                type VARCHAR(50) NOT NULL,
                description TEXT NOT NULL,
                target VARCHAR(100) NOT NULL,
                status VARCHAR(20) DEFAULT 'pending',
                code_changes JSONB,
                test_results JSONB,
                risk_assessment JSONB,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                applied_at TIMESTAMP,
                rolled_back_at TIMESTAMP
            )
        """))
        
        # Tabla de versiones
        conn.execute(text("""
            CREATE TABLE IF NOT EXISTS versions (
                id SERIAL PRIMARY KEY,
                application VARCHAR(50) NOT NULL,
                version VARCHAR(20) NOT NULL,
                description TEXT,
                changes JSONB,
                performance_metrics JSONB,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                is_active BOOLEAN DEFAULT FALSE
            )
        """))
        
        # Tabla de auditoría
        conn.execute(text("""
            CREATE TABLE IF NOT EXISTS audit_logs (
                id SERIAL PRIMARY KEY,
                admin_id INTEGER REFERENCES admins(id),
                action VARCHAR(100) NOT NULL,
                target VARCHAR(100),
                details JSONB,
                ip_address INET,
                user_agent TEXT,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        """))
        
        conn.commit()

def create_admin():
    """Crear administrador inicial"""
    print("🔐 Configuración del Administrador GESTEMA")
    print("=" * 50)
    
    username = input("Nombre de usuario del administrador: ")
    email = input("Email del administrador: ")
    password = input("Contraseña del administrador: ")
    
    # Verificar si ya existe
    with engine.connect() as conn:
        result = conn.execute(text("SELECT id FROM admins WHERE username = :username"), 
                            {"username": username}).fetchone()
        
        if result:
            print(f"❌ Usuario {username} ya existe")
            return
    
    # Generar secreto MFA
    mfa_secret = pyotp.random_base32()
    
    # Crear QR code para MFA
    totp_uri = pyotp.totp.TOTP(mfa_secret).provisioning_uri(
        name=email,
        issuer_name="GESTEMA ADMIN"
    )
    
    qr = qrcode.QRCode(version=1, box_size=10, border=5)
    qr.add_data(totp_uri)
    qr.make(fit=True)
    
    qr_img = qr.make_image(fill_color="black", back_color="white")
    qr_img.save("admin_mfa_qr.png")
    
    # Hash de contraseña
    hashed_password = pwd_context.hash(password)
    
    # Crear administrador
    with engine.connect() as conn:
        conn.execute(text("""
            INSERT INTO admins (username, email, hashed_password, full_name, mfa_secret, mfa_enabled)
            VALUES (:username, :email, :hashed_password, :full_name, :mfa_secret, :mfa_enabled)
        """), {
            "username": username,
            "email": email,
            "hashed_password": hashed_password,
            "full_name": "Administrador Principal",
            "mfa_secret": mfa_secret,
            "mfa_enabled": True
        })
        
        conn.commit()
    
    print(f"✅ Administrador {username} creado exitosamente")
    print(f"📱 Código QR para MFA guardado en: admin_mfa_qr.png")
    print(f"🔑 Secreto MFA: {mfa_secret}")
    print("\n📋 Instrucciones:")
    print("1. Instala una app de autenticación (Google Authenticator, Authy)")
    print("2. Escanea el código QR o ingresa el secreto manualmente")
    print("3. Guarda el código de respaldo en un lugar seguro")

if __name__ == "__main__":
    create_tables()
    create_admin()
EOF
    
    python create_admin.py
    rm create_admin.py
    
    deactivate
    cd ..
    
    print_success "Administrador inicial creado"
}

# Configurar servicios del sistema
setup_systemd_services() {
    print_status "Configurando servicios del sistema para ADMIN..."
    
    # Crear servicio para GESTEMA ADMIN
    sudo tee /etc/systemd/system/gestema-admin.service > /dev/null << EOF
[Unit]
Description=GESTEMA ADMIN Backend
After=network.target postgresql.service redis.service

[Service]
Type=simple
User=$USER
WorkingDirectory=$(pwd)
Environment=PATH=$(pwd)/backend/venv/bin
ExecStart=$(pwd)/backend/venv/bin/uvicorn main:app --host 127.0.0.1 --port 8001
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
    
    sudo systemctl daemon-reload
    sudo systemctl enable gestema-admin.service
    
    print_success "Servicios del sistema configurados"
}

# Configurar monitoreo del sistema
setup_monitoring() {
    print_status "Configurando monitoreo del sistema..."
    
    # Crear script de monitoreo
    cat > monitor_system.sh << 'EOF'
#!/bin/bash

# Script de monitoreo para GESTEMA ADMIN
LOG_FILE="./logs/system_monitor.log"
ALERT_THRESHOLD_CPU=80
ALERT_THRESHOLD_MEMORY=85
ALERT_THRESHOLD_DISK=90

while true; do
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    
    # CPU
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | awk -F'%' '{print $1}')
    
    # Memory
    MEMORY_USAGE=$(free | grep Mem | awk '{printf("%.2f"), $3/$2 * 100.0}')
    
    # Disk
    DISK_USAGE=$(df -h / | awk 'NR==2{print $5}' | sed 's/%//')
    
    # Log metrics
    echo "$TIMESTAMP - CPU: ${CPU_USAGE}%, Memory: ${MEMORY_USAGE}%, Disk: ${DISK_USAGE}%" >> $LOG_FILE
    
    # Check alerts
    if (( $(echo "$CPU_USAGE > $ALERT_THRESHOLD_CPU" | bc -l) )); then
        echo "$TIMESTAMP - ALERT: High CPU usage: ${CPU_USAGE}%" >> $LOG_FILE
    fi
    
    if (( $(echo "$MEMORY_USAGE > $ALERT_THRESHOLD_MEMORY" | bc -l) )); then
        echo "$TIMESTAMP - ALERT: High Memory usage: ${MEMORY_USAGE}%" >> $LOG_FILE
    fi
    
    if [ "$DISK_USAGE" -gt "$ALERT_THRESHOLD_DISK" ]; then
        echo "$TIMESTAMP - ALERT: High Disk usage: ${DISK_USAGE}%" >> $LOG_FILE
    fi
    
    sleep 30
done
EOF
    
    chmod +x monitor_system.sh
    
    print_success "Monitoreo del sistema configurado"
}

# Función principal
main() {
    echo "🔧 GESTEMA ADMIN - Configuración Inicial"
    echo "========================================"
    
    check_os
    check_gestema_trading
    install_system_dependencies
    setup_postgresql
    setup_redis
    setup_python_env
    setup_node_env
    create_directories
    setup_environment
    create_admin_user
    setup_systemd_services
    setup_monitoring
    
    echo ""
    echo "🎉 ¡Configuración de GESTEMA ADMIN completada!"
    echo ""
    echo "📋 Próximos pasos:"
    echo "1. Iniciar el backend: sudo systemctl start gestema-admin"
    echo "2. Iniciar el frontend: cd frontend && npm run dev"
    echo "3. Acceder a: http://localhost:3001"
    echo ""
    echo "🔧 Comandos útiles:"
    echo "- Ver logs: sudo journalctl -u gestema-admin -f"
    echo "- Reiniciar: sudo systemctl restart gestema-admin"
    echo "- Estado: sudo systemctl status gestema-admin"
    echo "- Monitoreo: ./monitor_system.sh"
    echo ""
    echo "🔐 Seguridad:"
    echo "- MFA obligatorio para administradores"
    echo "- Logs de auditoría en: ./logs/admin_audit.log"
    echo "- Vault de credenciales en: ./vault/"
    echo ""
    echo "📚 Documentación: ./docs_admin/"
    echo "🧪 Staging: ./staging/"
    echo ""
}

# Ejecutar función principal
main "$@"