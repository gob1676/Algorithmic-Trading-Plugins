# GESTEMA TRADING - Dockerfile
FROM python:3.11-slim

# Metadatos
LABEL maintainer="GESTEMA Team"
LABEL description="GESTEMA TRADING - Plataforma de trading con Multi-IA"
LABEL version="1.0.0"

# Variables de entorno
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    libssl-dev \
    libffi-dev \
    pkg-config \
    libhdf5-dev \
    libblas-dev \
    liblapack-dev \
    gfortran \
    curl \
    wget \
    git \
    && rm -rf /var/lib/apt/lists/*

# Crear usuario no-root
RUN groupadd -r gestema && useradd -r -g gestema gestema

# Crear directorio de trabajo
WORKDIR /app

# Copiar archivos de dependencias
COPY backend/requirements.txt .

# Instalar dependencias de Python
RUN pip install --no-cache-dir --upgrade pip setuptools wheel
RUN pip install --no-cache-dir -r requirements.txt

# Copiar código de la aplicación
COPY backend/ .

# Crear directorios necesarios
RUN mkdir -p logs data reports backup plugins config

# Establecer permisos
RUN chown -R gestema:gestema /app
RUN chmod -R 755 /app

# Cambiar a usuario no-root
USER gestema

# Exponer puerto
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

# Comando por defecto
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]