# GESTEMA Trading - Dockerfile
FROM python:3.11-slim

# Información del contenedor
LABEL maintainer="GESTEMA Team"
LABEL description="GESTEMA Trading - Plataforma de Trading Inteligente con Multi-IA"
LABEL version="1.0.0"

# Variables de entorno
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    sqlite3 \
    postgresql-client \
    redis-tools \
    libpq-dev \
    libffi-dev \
    libssl-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Crear usuario no-root
RUN groupadd -r gestema && useradd -r -g gestema gestema

# Crear directorios de trabajo
WORKDIR /app

# Crear estructura de directorios
RUN mkdir -p \
    data/{users,portfolios,transactions,market_data} \
    reports/{pdf,excel,templates} \
    backup/{daily,weekly,monthly} \
    config/secrets \
    logs \
    ia_committee/models \
    plugins

# Copiar requirements y instalar dependencias Python
COPY backend/requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Instalar dependencias adicionales para IA
RUN pip install --no-cache-dir \
    torch==2.1.2 \
    transformers==4.36.2 \
    scikit-learn==1.3.2 \
    pandas==2.1.4 \
    numpy==1.25.2 \
    prophet==1.1.5 \
    xgboost==2.0.3 \
    tensorflow==2.15.0 \
    yfinance==0.2.28 \
    alpaca-trade-api==3.1.1

# Copiar código de la aplicación
COPY backend/ ./
COPY ia_committee/ ./ia_committee/
COPY brokers/ ./brokers/
COPY plugins/ ./plugins/
COPY config/ ./config/
COPY docs/ ./docs/

# Configurar permisos
RUN chown -R gestema:gestema /app && \
    chmod -R 755 /app && \
    chmod -R 700 /app/data /app/config/secrets

# Crear script de inicialización
RUN cat > /app/init.sh << 'EOF'
#!/bin/bash
set -e

echo "Inicializando GESTEMA Trading..."

# Verificar base de datos
if [ ! -f "/app/data/gestema.db" ]; then
    echo "Creando base de datos inicial..."
    python -c "
from app.core.database import engine, Base
from app.models import *
Base.metadata.create_all(bind=engine)
print('Base de datos inicializada')
"
fi

# Verificar configuración
if [ ! -f "/app/config/.env" ]; then
    echo "Creando configuración por defecto..."
    cp /app/config/.env.example /app/config/.env
fi

# Inicializar modelos de IA si no existen
if [ ! -d "/app/ia_committee/models/downloaded" ]; then
    echo "Descargando modelos de IA básicos..."
    python -c "
import os
os.makedirs('/app/ia_committee/models/downloaded', exist_ok=True)
print('Directorio de modelos creado')
"
fi

echo "Inicialización completada"
exec "$@"
EOF

RUN chmod +x /app/init.sh

# Cambiar al usuario no-root
USER gestema

# Exponer puerto
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

# Comando de inicio
ENTRYPOINT ["/app/init.sh"]
CMD ["python", "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]