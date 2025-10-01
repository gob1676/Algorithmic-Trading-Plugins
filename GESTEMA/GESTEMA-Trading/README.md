# GESTEMA TRADING

## Descripción
Plataforma principal para supervisar, comprar y vender ETFs con ayuda de diversas IAs. Aplicación local, segura y modular para Zorin OS.

## Características Principales

### 🎯 Trading Multi-Modal
- **Manual**: Órdenes directas del usuario
- **Simulado**: Práctica sin riesgo real
- **Prueba Realista**: Simulación con datos reales
- **Real**: Trading con brokers integrados
- **Automático**: Supervisado por Multi-IA

### 🤖 Comité Multi-IA
- **Predictivas**: Prophet, ARIMA, RandomForest, XGBoost, LSTM/GRU
- **Explicativas**: Qwen, Mistral, FinBERT
- **Optimizadoras**: PyPortfolioOpt
- **Asistente**: Qwen/Mistral instruct

### 🎮 Gamificación Educativa
- Sistema XP, logros y niveles
- Escenarios históricos reproducibles
- Exámenes IA para evaluar conocimiento
- Ranking local de rendimiento

### 🔌 Sistema de Plugins
- Indicadores técnicos
- Nuevas IAs
- Nuevos brokers
- Dashboards personalizados
- Fuentes de datos

### 🔒 Seguridad
- Registro/login con bcrypt/argon2
- JWT + MFA opcional
- Carpeta cifrada AES-256
- Keys API broker en vault local
- Logs firmados hash

## Estructura del Proyecto

```
GESTEMA-Trading/
├── frontend/          # React + TypeScript + Tailwind
├── backend/           # FastAPI + SQLAlchemy
├── ia_committee/      # Módulos de IA
├── brokers/           # Integraciones con brokers
├── plugins/           # Sistema de plugins
├── docs/              # Documentación
├── config/            # Configuraciones
├── data/              # Datos cifrados
├── reports/           # Reportes PDF/Excel
└── backup/            # Respaldos
```

## Brokers Soportados
- ✅ Alpaca (sandbox + real)
- 🔄 Interactive Brokers
- 🔄 TD Ameritrade / Charles Schwab
- 🔄 Robinhood (opcional)

## Instalación

### Prerrequisitos
- Python 3.11+
- Node.js 18+
- PostgreSQL 14+
- Redis 6+

### Instalación Local
```bash
# Clonar repositorio
git clone <repository-url>
cd GESTEMA-Trading

# Backend
cd backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Frontend
cd ../frontend
npm install
npm run dev
```

## Uso

### Primera Configuración
1. Ejecutar `setup.sh` para configuración inicial
2. Crear usuario administrador
3. Configurar brokers (opcional)
4. Activar plugins deseados

### Trading
1. Iniciar sesión
2. Seleccionar modo de trading
3. Configurar estrategias IA
4. Monitorear rendimiento

## Desarrollo

### Estructura de Plugins
```yaml
# plugin.yml
name: "Mi Plugin"
version: "1.0.0"
type: "indicator"  # indicator, ai, broker, dashboard, datasource
description: "Descripción del plugin"
author: "Tu Nombre"
dependencies:
  - "numpy>=1.21.0"
entry_point: "main.py"
```

### API REST
- `/api/v1/auth/` - Autenticación
- `/api/v1/trading/` - Operaciones de trading
- `/api/v1/ai/` - Comité de IA
- `/api/v1/portfolio/` - Gestión de portafolio
- `/api/v1/plugins/` - Gestión de plugins

## Contribuir
1. Fork del repositorio
2. Crear rama feature
3. Implementar cambios
4. Tests y documentación
5. Pull request

## Licencia
Gratuita para uso personal y comercial.

## Soporte
- Documentación: `/docs/`
- Issues: GitHub Issues
- Comunidad: Discord (próximamente)