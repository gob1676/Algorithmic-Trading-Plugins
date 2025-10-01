#!/bin/bash

# GESTEMA TRADING - Script de Configuración Inicial
# Para Zorin OS (Ubuntu/Debian)

set -e

echo "🚀 Iniciando configuración de GESTEMA TRADING..."

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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
        libhdf5-dev \
        libblas-dev \
        liblapack-dev \
        gfortran
    
    print_success "Dependencias del sistema instaladas"
}

# Configurar PostgreSQL
setup_postgresql() {
    print_status "Configurando PostgreSQL..."
    
    sudo systemctl start postgresql
    sudo systemctl enable postgresql
    
    # Crear usuario y base de datos
    sudo -u postgres psql -c "CREATE USER gestema WITH PASSWORD 'gestema123';"
    sudo -u postgres psql -c "CREATE DATABASE gestema_trading OWNER gestema;"
    sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE gestema_trading TO gestema;"
    
    print_success "PostgreSQL configurado"
}

# Configurar Redis
setup_redis() {
    print_status "Configurando Redis..."
    
    sudo systemctl start redis-server
    sudo systemctl enable redis-server
    
    # Configurar Redis para persistencia
    sudo sed -i 's/^# save 900 1/save 900 1/' /etc/redis/redis.conf
    sudo sed -i 's/^# save 300 10/save 300 10/' /etc/redis/redis.conf
    sudo sed -i 's/^# save 60 10000/save 60 10000/' /etc/redis/redis.conf
    
    sudo systemctl restart redis-server
    
    print_success "Redis configurado"
}

# Configurar entorno Python
setup_python_env() {
    print_status "Configurando entorno Python..."
    
    cd backend
    
    # Crear entorno virtual
    python3.11 -m venv venv
    source venv/bin/activate
    
    # Actualizar pip
    pip install --upgrade pip setuptools wheel
    
    # Instalar dependencias
    if [ -f "requirements.txt" ]; then
        pip install -r requirements.txt
    else
        # Crear requirements.txt básico
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
passlib[bcrypt]==1.7.4
python-multipart==0.0.6
pyyaml==6.0.1
pandas==2.1.4
numpy==1.25.2
scikit-learn==1.3.2
prophet==1.1.4
torch==2.1.1
transformers==4.36.2
pyportfolioopt==1.5.5
alpaca-trade-api==3.0.0
yfinance==0.2.28
ta-lib==0.4.28
matplotlib==3.8.2
plotly==5.17.0
jinja2==3.1.2
aiofiles==23.2.1
httpx==0.25.2
cryptography==41.0.8
argon2-cffi==23.1.0
qrcode[pil]==7.4.2
pyotp==2.9.0
EOF
        pip install -r requirements.txt
    fi
    
    deactivate
    cd ..
    
    print_success "Entorno Python configurado"
}

# Configurar entorno Node.js
setup_node_env() {
    print_status "Configurando entorno Node.js..."
    
    cd frontend
    
    # Verificar si package.json existe
    if [ ! -f "package.json" ]; then
        # Crear package.json básico
        cat > package.json << EOF
{
  "name": "gestema-trading-frontend",
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
    "tailwind-merge": "^2.0.0"
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
    fi
    
    # Instalar dependencias
    npm install
    
    cd ..
    
    print_success "Entorno Node.js configurado"
}

# Crear directorios necesarios
create_directories() {
    print_status "Creando directorios necesarios..."
    
    mkdir -p logs
    mkdir -p data
    mkdir -p reports
    mkdir -p backup
    mkdir -p plugins
    
    # Establecer permisos
    chmod 755 logs data reports backup plugins
    
    print_success "Directorios creados"
}

# Configurar variables de entorno
setup_environment() {
    print_status "Configurando variables de entorno..."
    
    cat > .env << EOF
# GESTEMA TRADING - Variables de Entorno
ENVIRONMENT=development
DEBUG=true
SECRET_KEY=your-secret-key-change-in-production-$(openssl rand -hex 32)
DATABASE_URL=postgresql://gestema:gestema123@localhost:5432/gestema_trading
REDIS_URL=redis://localhost:6379/0
ENCRYPTION_KEY=$(openssl rand -hex 32)

# Brokers (opcional)
ALPACA_API_KEY=
ALPACA_SECRET_KEY=
ALPACA_BASE_URL=https://paper-api.alpaca.markets

# IA Models
HUGGINGFACE_API_TOKEN=
OPENAI_API_KEY=

# Logging
LOG_LEVEL=INFO
LOG_FILE=./logs/gestema_trading.log
EOF
    
    chmod 600 .env
    
    print_success "Variables de entorno configuradas"
}

# Crear usuario inicial
create_initial_user() {
    print_status "Creando usuario inicial..."
    
    cd backend
    source venv/bin/activate
    
    # Crear script para usuario inicial
    cat > create_user.py << 'EOF'
import asyncio
import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from passlib.context import CryptContext
from datetime import datetime

# Configuración básica
DATABASE_URL = "postgresql://gestema:gestema123@localhost:5432/gestema_trading"
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def create_tables():
    """Crear tablas básicas"""
    from sqlalchemy import text
    
    with engine.connect() as conn:
        # Tabla de usuarios
        conn.execute(text("""
            CREATE TABLE IF NOT EXISTS users (
                id SERIAL PRIMARY KEY,
                username VARCHAR(50) UNIQUE NOT NULL,
                email VARCHAR(100) UNIQUE NOT NULL,
                hashed_password VARCHAR(255) NOT NULL,
                full_name VARCHAR(100),
                is_active BOOLEAN DEFAULT TRUE,
                is_admin BOOLEAN DEFAULT FALSE,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        """))
        
        # Tabla de portafolios
        conn.execute(text("""
            CREATE TABLE IF NOT EXISTS portfolios (
                id SERIAL PRIMARY KEY,
                user_id INTEGER REFERENCES users(id),
                name VARCHAR(100) NOT NULL,
                balance DECIMAL(15,2) DEFAULT 0.00,
                currency VARCHAR(3) DEFAULT 'USD',
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        """))
        
        conn.commit()

def create_admin_user():
    """Crear usuario administrador inicial"""
    username = input("Ingrese nombre de usuario para el administrador: ")
    email = input("Ingrese email del administrador: ")
    password = input("Ingrese contraseña del administrador: ")
    
    hashed_password = pwd_context.hash(password)
    
    with engine.connect() as conn:
        from sqlalchemy import text
        
        # Verificar si el usuario ya existe
        result = conn.execute(text("SELECT id FROM users WHERE username = :username"), 
                            {"username": username}).fetchone()
        
        if result:
            print(f"Usuario {username} ya existe")
            return
        
        # Crear usuario
        conn.execute(text("""
            INSERT INTO users (username, email, hashed_password, full_name, is_active, is_admin)
            VALUES (:username, :email, :hashed_password, :full_name, :is_active, :is_admin)
        """), {
            "username": username,
            "email": email,
            "hashed_password": hashed_password,
            "full_name": "Administrador",
            "is_active": True,
            "is_admin": True
        })
        
        # Crear portafolio inicial
        user_result = conn.execute(text("SELECT id FROM users WHERE username = :username"), 
                                 {"username": username}).fetchone()
        
        conn.execute(text("""
            INSERT INTO portfolios (user_id, name, balance, currency)
            VALUES (:user_id, :name, :balance, :currency)
        """), {
            "user_id": user_result[0],
            "name": "Portafolio Principal",
            "balance": 10000.00,
            "currency": "USD"
        })
        
        conn.commit()
        print(f"Usuario administrador {username} creado exitosamente")

if __name__ == "__main__":
    create_tables()
    create_admin_user()
EOF
    
    python create_user.py
    rm create_user.py
    
    deactivate
    cd ..
    
    print_success "Usuario inicial creado"
}

# Configurar servicios del sistema
setup_systemd_services() {
    print_status "Configurando servicios del sistema..."
    
    # Crear servicio para GESTEMA TRADING
    sudo tee /etc/systemd/system/gestema-trading.service > /dev/null << EOF
[Unit]
Description=GESTEMA TRADING Backend
After=network.target postgresql.service redis.service

[Service]
Type=simple
User=$USER
WorkingDirectory=$(pwd)
Environment=PATH=$(pwd)/backend/venv/bin
ExecStart=$(pwd)/backend/venv/bin/uvicorn main:app --host 127.0.0.1 --port 8000
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
    
    sudo systemctl daemon-reload
    sudo systemctl enable gestema-trading.service
    
    print_success "Servicios del sistema configurados"
}

# Función principal
main() {
    echo "🎯 GESTEMA TRADING - Configuración Inicial"
    echo "=========================================="
    
    check_os
    install_system_dependencies
    setup_postgresql
    setup_redis
    setup_python_env
    setup_node_env
    create_directories
    setup_environment
    create_initial_user
    setup_systemd_services
    
    echo ""
    echo "🎉 ¡Configuración completada exitosamente!"
    echo ""
    echo "📋 Próximos pasos:"
    echo "1. Iniciar el backend: sudo systemctl start gestema-trading"
    echo "2. Iniciar el frontend: cd frontend && npm run dev"
    echo "3. Acceder a: http://localhost:3000"
    echo ""
    echo "🔧 Comandos útiles:"
    echo "- Ver logs: sudo journalctl -u gestema-trading -f"
    echo "- Reiniciar: sudo systemctl restart gestema-trading"
    echo "- Estado: sudo systemctl status gestema-trading"
    echo ""
    echo "📚 Documentación: ./docs/"
    echo "🔌 Plugins: ./plugins/"
    echo ""
}

# Ejecutar función principal
main "$@"