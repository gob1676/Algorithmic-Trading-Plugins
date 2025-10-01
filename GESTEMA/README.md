# 🚀 GESTEMA - Ecosistema de Trading con Multi-IA

<div align="center">
  <img src="https://via.placeholder.com/400x200/4F46E5/FFFFFF?text=GESTEMA+TRADING" alt="GESTEMA TRADING Logo" width="400"/>
  
  <p><strong>Plataforma completa de trading con Inteligencia Artificial para ETFs</strong></p>
  
  [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
  [![Python 3.11+](https://img.shields.io/badge/python-3.11+-blue.svg)](https://www.python.org/downloads/)
  [![React 18](https://img.shields.io/badge/react-18-blue.svg)](https://reactjs.org/)
  [![FastAPI](https://img.shields.io/badge/FastAPI-0.104+-green.svg)](https://fastapi.tiangolo.com/)
  [![Docker](https://img.shields.io/badge/docker-ready-blue.svg)](https://www.docker.com/)
</div>

## 📋 Descripción

GESTEMA es un ecosistema completo de aplicaciones de trading con Inteligencia Artificial integrada, diseñado específicamente para Zorin OS (Ubuntu/Debian). El sistema está compuesto por dos aplicaciones principales que trabajan de forma interconectada:

### 🎯 GESTEMA TRADING
Plataforma principal para supervisar, comprar y vender ETFs con ayuda de diversas IAs, incluyendo:
- Trading manual, simulado, prueba realista y real
- Comité Multi-IA con módulos predictivos, explicativos y optimizadores
- Gamificación educativa con escenarios históricos
- Sistema de plugins modular y extensible
- Integración con múltiples brokers

### 🔧 GESTEMA ADMIN
Aplicación de administración y mantenimiento exclusiva para el creador, que permite:
- Mantener y actualizar GESTEMA TRADING de forma segura
- Entorno de staging para pruebas antes de implementar cambios
- IA intérprete que convierte órdenes en código
- Monitoreo del sistema y gestión de recursos
- Control de versiones con rollback automático

## ✨ Características Principales

### 🔒 Seguridad y Privacidad
- ✅ 100% Local - Sin dependencias de servicios externos
- ✅ Almacenamiento cifrado AES-256
- ✅ Autenticación JWT + MFA opcional
- ✅ Logs de auditoría inmutables
- ✅ Vault local para credenciales de brokers

### 🤖 Inteligencia Artificial
- **Predictivas**: Prophet, ARIMA, RandomForest, XGBoost, LSTM/GRU
- **Explicativas**: Qwen, Mistral, FinBERT
- **Optimizadoras**: PyPortfolioOpt
- **Asistente**: Qwen/Mistral instruct
- **Comité de votación** para consenso en decisiones de trading

### 🎮 Gamificación Educativa
- Sistema XP, logros y niveles
- Escenarios históricos reproducibles (Crisis 2008, COVID 2020, etc.)
- Exámenes IA para evaluar conocimiento
- Ranking local de rendimiento educativo

### 🔌 Extensibilidad
- Sistema de plugins modular
- Tipos: indicadores, nuevas IA, brokers, dashboards, fuentes de datos
- Activación desde frontend
- API REST completa

### 🌐 Accesibilidad e Internacionalización
- Soporte para lectores de pantalla
- Contraste alto y navegación por teclado
- Internacionalización (español/inglés)
- Interfaz responsive y moderna

## 🏗️ Arquitectura

```
GESTEMA/
├── GESTEMA-Trading/          # Aplicación principal de trading
│   ├── frontend/             # React + TypeScript + Tailwind
│   ├── backend/              # FastAPI + SQLAlchemy
│   ├── ia_committee/         # Módulos de IA
│   ├── brokers/              # Integraciones con brokers
│   ├── plugins/              # Sistema de plugins
│   └── ...
├── GESTEMA-Admin/            # Panel de administración
│   ├── frontend/             # React + TypeScript
│   ├── backend/              # FastAPI + SQLAlchemy
│   ├── staging/              # Entorno de pruebas
│   ├── ia_interpreter/       # IA que interpreta cambios
│   └── ...
└── docker-compose.yml        # Orquestación de contenedores
```

## 🚀 Instalación Rápida

### Prerrequisitos
- Zorin OS 16+ (Ubuntu 20.04+ / Debian 11+)
- Docker y Docker Compose
- 8GB RAM mínimo (16GB recomendado)
- 50GB espacio en disco

### Instalación con Docker (Recomendado)

```bash
# Clonar el repositorio
git clone https://github.com/gestema/gestema.git
cd gestema

# Configurar variables de entorno
cp .env.example .env
# Editar .env con tus configuraciones

# Iniciar todos los servicios
docker-compose up -d

# Verificar que todo esté funcionando
docker-compose ps
```

### Instalación Manual

```bash
# GESTEMA TRADING
cd GESTEMA-Trading
chmod +x setup.sh
./setup.sh

# GESTEMA ADMIN (en otra terminal)
cd GESTEMA-Admin
chmod +x setup_admin.sh
./setup_admin.sh
```

## 🌐 Acceso a las Aplicaciones

Una vez instalado, puedes acceder a:

- **GESTEMA TRADING**: http://localhost:3000
- **GESTEMA ADMIN**: http://localhost:3001
- **API Trading**: http://localhost:8000/docs
- **API Admin**: http://localhost:8001/docs

## 📊 Brokers Soportados

| Broker | Estado | Sandbox | Real | Documentación |
|--------|--------|---------|------|---------------|
| Alpaca | ✅ Activo | ✅ | ✅ | [Ver docs](docs/brokers/alpaca.md) |
| Interactive Brokers | 🔄 En desarrollo | ✅ | 🔄 | [Ver docs](docs/brokers/ib.md) |
| TD Ameritrade | 🔄 En desarrollo | ✅ | 🔄 | [Ver docs](docs/brokers/td.md) |
| Charles Schwab | 🔄 En desarrollo | ✅ | 🔄 | [Ver docs](docs/brokers/schwab.md) |
| Robinhood | 🔄 Opcional | ✅ | 🔄 | [Ver docs](docs/brokers/robinhood.md) |

## 🧠 Modelos de IA Integrados

### Predictivos
- **Prophet**: Predicción de series temporales
- **ARIMA/SARIMAX**: Análisis estadístico avanzado
- **RandomForest**: Ensemble learning
- **XGBoost**: Gradient boosting
- **LSTM/GRU**: Redes neuronales recurrentes

### Explicativos
- **Qwen**: Modelo de lenguaje para explicaciones
- **Mistral**: Análisis de sentimiento financiero
- **FinBERT**: BERT especializado en finanzas

### Optimizadores
- **PyPortfolioOpt**: Optimización de portafolio
- **Risk Parity**: Distribución de riesgo
- **Black-Litterman**: Modelo de equilibrio

## 🔌 Sistema de Plugins

Los plugins permiten extender la funcionalidad de GESTEMA:

```yaml
# plugin.yml
name: "Mi Indicador Personalizado"
version: "1.0.0"
type: "indicator"
description: "Indicador técnico personalizado"
author: "Tu Nombre"
dependencies:
  - "numpy>=1.21.0"
entry_point: "main.py"
```

### Tipos de Plugins
- **Indicadores**: Nuevos indicadores técnicos
- **IA Models**: Modelos de IA personalizados
- **Brokers**: Integraciones con nuevos brokers
- **Dashboards**: Paneles personalizados
- **Datasources**: Nuevas fuentes de datos

## 🎮 Gamificación

### Sistema de Progresión
- **XP por operación**: 10 puntos base
- **Logros especiales**: 50-500 puntos
- **Niveles**: Novato → Aprendiz → Intermedio → Avanzado → Experto → Maestro

### Escenarios Históricos
- Crisis Financiera 2008
- Pandemia COVID-19 2020
- Inflación 2022
- Dot-com Bubble 2000
- Y más...

## 🔧 GESTEMA ADMIN

### Funcionalidades Principales
- **Localizador**: Encuentra instalaciones de GESTEMA TRADING
- **Staging**: Entorno de pruebas para cambios
- **IA Intérprete**: Convierte órdenes en código
- **Monitoreo**: Salud del sistema en tiempo real
- **Versionado**: Control de versiones con rollback

### Comandos de IA
```
"Agregar indicador RSI al dashboard"
"Optimizar algoritmo de trading automático"
"Actualizar dependencias de seguridad"
"Crear nuevo plugin de análisis técnico"
```

## 📈 Roadmap de Desarrollo

### ✅ Fase 1 - Estructura Inicial (Completada)
- [x] Crear estructura de directorios
- [x] Configurar repositorios base
- [x] Documentación inicial

### 🔄 Fase 2 - Backend Trading Base
- [ ] Configurar FastAPI
- [ ] Estructura de base de datos
- [ ] API REST básica
- [ ] Sistema de logging

### 🔄 Fase 3 - Frontend Trading Base
- [ ] Configurar React con Vite
- [ ] Diseño basado en logo GESTEMA
- [ ] Componentes base
- [ ] Routing y navegación

### 🔄 Fases 4-16
Ver [roadmap completo](global_docs/roadmap.md) para detalles de todas las fases.

## 🛠️ Desarrollo

### Estructura del Proyecto
```
GESTEMA/
├── GESTEMA-Trading/          # Aplicación principal
│   ├── frontend/             # React + TypeScript
│   ├── backend/              # FastAPI + Python
│   ├── ia_committee/         # Modelos de IA
│   ├── brokers/              # Integraciones
│   ├── plugins/              # Sistema de plugins
│   ├── docs/                 # Documentación
│   └── config/               # Configuraciones
├── GESTEMA-Admin/            # Panel de administración
│   ├── frontend/             # React + TypeScript
│   ├── backend/              # FastAPI + Python
│   ├── staging/              # Entorno de pruebas
│   ├── docs_admin/           # Documentación admin
│   └── config/               # Configuraciones
└── global_docs/              # Documentación global
```

### Tecnologías Utilizadas

#### Frontend
- **React 18** + TypeScript
- **Vite** (build tool)
- **Tailwind CSS** (styling)
- **React Router** (navegación)
- **React Query** (estado servidor)
- **Framer Motion** (animaciones)

#### Backend
- **FastAPI** (Python)
- **SQLAlchemy** (ORM)
- **Alembic** (migraciones)
- **Redis** (cache)
- **Celery** (tareas asíncronas)
- **Pydantic** (validación)

#### IA y ML
- **Prophet** (predicción temporal)
- **scikit-learn** (ML general)
- **PyTorch** (deep learning)
- **Transformers** (LLMs)
- **PyPortfolioOpt** (optimización)

#### Infraestructura
- **Docker** + Docker Compose
- **PostgreSQL** (base de datos)
- **Redis** (cache y colas)
- **Nginx** (proxy reverso)

## 📚 Documentación

- [Guía de Instalación](docs/installation.md)
- [Configuración de Brokers](docs/brokers/)
- [Sistema de Plugins](docs/plugins/)
- [API Reference](docs/api/)
- [GESTEMA ADMIN](docs/admin/)
- [Troubleshooting](docs/troubleshooting.md)

## 🤝 Contribuir

1. Fork del repositorio
2. Crear rama feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit cambios (`git commit -am 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Crear Pull Request

### Guías de Contribución
- [Código de Conducta](CODE_OF_CONDUCT.md)
- [Guía de Contribución](CONTRIBUTING.md)
- [Estándares de Código](docs/development/coding-standards.md)

## 📄 Licencia

Este proyecto está licenciado bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## 🆘 Soporte

- **Documentación**: [docs/](docs/)
- **Issues**: [GitHub Issues](https://github.com/gestema/gestema/issues)
- **Discusiones**: [GitHub Discussions](https://github.com/gestema/gestema/discussions)
- **Comunidad**: [Discord](https://discord.gg/gestema) (próximamente)

## 🙏 Agradecimientos

- [FastAPI](https://fastapi.tiangolo.com/) - Framework web moderno
- [React](https://reactjs.org/) - Biblioteca de UI
- [Prophet](https://facebook.github.io/prophet/) - Predicción de series temporales
- [PyPortfolioOpt](https://pyportfolioopt.readthedocs.io/) - Optimización de portafolio
- [Alpaca](https://alpaca.markets/) - API de trading
- [Hugging Face](https://huggingface.co/) - Modelos de IA

## 📊 Estadísticas del Proyecto

![GitHub stars](https://img.shields.io/github/stars/gestema/gestema?style=social)
![GitHub forks](https://img.shields.io/github/forks/gestema/gestema?style=social)
![GitHub issues](https://img.shields.io/github/issues/gestema/gestema)
![GitHub pull requests](https://img.shields.io/github/issues-pr/gestema/gestema)

---

<div align="center">
  <p><strong>Desarrollado con ❤️ para la comunidad de trading</strong></p>
  <p>GESTEMA - Donde la IA se encuentra con el trading</p>
</div>