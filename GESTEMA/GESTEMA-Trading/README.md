# 📈 GESTEMA TRADING

## 🎯 Descripción

GESTEMA TRADING es la plataforma principal del ecosistema GESTEMA, diseñada para supervisar, comprar y vender ETFs con ayuda de un comité de inteligencias artificiales especializadas.

## ✨ Características Principales

### 📊 Dashboard ETFs
- Precios en tiempo real
- Gráficas interactivas avanzadas
- Análisis de variaciones y tendencias
- Alertas personalizables

### 🎮 Panel de Órdenes Multi-Modo
- **Manual**: Control total del usuario
- **Simulado**: Trading sin riesgo real
- **Modo Prueba Realista**: Simulación con datos reales históricos
- **Real**: Trading con brokers integrados
- **Automático Supervisado**: IA toma decisiones con supervisión humana

### 🤖 Comité Multi-IA Supervisora
- **IAs Predictivas**: Prophet, ARIMA/SARIMAX, RandomForest, XGBoost, LSTM/GRU
- **IAs Explicativas**: Qwen/Mistral (LLM), FinBERT
- **IA Optimizadora**: PyPortfolioOpt
- **Asistente IA**: Qwen pequeño/Mistral instruct
- **Sistema de Votación**: Consenso inteligente para decisiones

### 🎓 Academia Gamificada
- Sistema XP, logros y niveles
- Escenarios históricos reproducibles:
  - Crisis 2008
  - COVID 2020
  - Inflación 2022
- Exámenes IA para evaluar conocimiento
- Ranking local de rendimiento educativo

### 🔌 Brokers Integrados
- **Alpaca**: Sandbox + Real (Prioritario)
- **Interactive Brokers**: Global
- **TD Ameritrade / Charles Schwab**: US Markets
- **Robinhood**: Opcional

### 🧩 Sistema de Plugins
- Carpeta `/plugins/` con `plugin.yml`
- Tipos soportados:
  - Indicadores técnicos personalizados
  - Nuevas IAs especializadas
  - Nuevos brokers
  - Dashboards personalizados
  - Fuentes de datos alternativas
- Activación desde frontend

### 🛡️ Seguridad Avanzada
- Registro/login con contraseñas bcrypt/argon2
- JWT + MFA opcional
- Carpeta cifrada AES-256
- Keys API broker en vault local
- Logs firmados con hash
- Auditoría inmutable

### 🌍 Accesibilidad e Internacionalización
- Soporte para lectores de pantalla
- Contrastes ajustables
- Navegación por teclado
- Idiomas: Español e Inglés (mínimo)

## 📁 Estructura del Proyecto

```
GESTEMA-Trading/
├── frontend/                   # React + TypeScript
│   ├── src/
│   │   ├── components/         # Componentes reutilizables
│   │   ├── pages/             # Páginas principales
│   │   ├── hooks/             # Custom hooks
│   │   ├── services/          # Servicios API
│   │   ├── store/             # Estado global (Redux/Zustand)
│   │   ├── utils/             # Utilidades
│   │   ├── assets/            # Recursos estáticos
│   │   └── i18n/              # Internacionalización
│   ├── public/
│   └── package.json
│
├── backend/                    # FastAPI + Python
│   ├── app/
│   │   ├── api/               # Endpoints API
│   │   ├── core/              # Configuración core
│   │   ├── models/            # Modelos de datos
│   │   ├── services/          # Lógica de negocio
│   │   ├── utils/             # Utilidades
│   │   └── main.py            # Punto de entrada
│   ├── tests/                 # Tests unitarios
│   └── requirements.txt
│
├── ia_committee/               # Comité Multi-IA
│   ├── predictive/            # IAs predictivas
│   ├── explanatory/           # IAs explicativas
│   ├── optimizer/             # IA optimizadora
│   ├── assistant/             # Asistente IA
│   ├── committee/             # Sistema de votación
│   └── models/                # Modelos entrenados
│
├── brokers/                    # Integraciones brokers
│   ├── alpaca/                # Integración Alpaca
│   ├── interactive_brokers/   # Integración IB
│   ├── td_ameritrade/         # Integración TDA
│   ├── base/                  # Clases base
│   └── factory.py             # Factory pattern
│
├── plugins/                    # Sistema de plugins
│   ├── indicators/            # Indicadores técnicos
│   ├── ai_models/             # Modelos IA adicionales
│   ├── data_sources/          # Fuentes de datos
│   └── dashboards/            # Dashboards personalizados
│
├── docs/                       # Documentación
│   ├── api/                   # Documentación API
│   ├── user_guide/            # Guía de usuario
│   ├── developer_guide/       # Guía desarrollador
│   └── changelog.md           # Registro de cambios
│
├── config/                     # Configuraciones
│   ├── settings.py            # Configuración principal
│   ├── database.py            # Configuración BD
│   └── security.py            # Configuración seguridad
│
├── data/                       # Datos cifrados
│   ├── users/                 # Datos de usuarios
│   ├── portfolios/            # Portfolios
│   ├── transactions/          # Transacciones
│   └── market_data/           # Datos de mercado
│
├── reports/                    # Reportes generados
│   ├── pdf/                   # Reportes PDF
│   ├── excel/                 # Reportes Excel
│   └── templates/             # Plantillas
│
├── backup/                     # Respaldos automáticos
│   ├── daily/                 # Respaldos diarios
│   ├── weekly/                # Respaldos semanales
│   └── monthly/               # Respaldos mensuales
│
├── docker-compose.yml          # Orquestación Docker
├── Dockerfile                  # Imagen Docker
├── setup.sh                    # Script de instalación
└── requirements.txt            # Dependencias Python
```

## 🚀 Instalación y Configuración

### Requisitos Previos
- Zorin OS (Ubuntu/Debian)
- Python 3.9+
- Node.js 18+
- Docker 20.10+
- 8GB RAM mínimo (16GB recomendado)

### Instalación Rápida
```bash
# Clonar el repositorio
git clone <repository-url>
cd GESTEMA/GESTEMA-Trading

# Ejecutar script de instalación
chmod +x setup.sh
./setup.sh

# O usar Docker
docker-compose up -d
```

### Configuración Manual
```bash
# Backend
cd backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Frontend
cd ../frontend
npm install
npm start

# Base de datos
python -m alembic upgrade head
```

## 🔧 Configuración

### Variables de Entorno
```bash
# .env
DATABASE_URL=sqlite:///./data/gestema.db
SECRET_KEY=your-secret-key-here
ALPACA_API_KEY=your-alpaca-key
ALPACA_SECRET_KEY=your-alpaca-secret
ENVIRONMENT=development
```

### Configuración de Brokers
1. Crear cuenta en Alpaca (sandbox)
2. Obtener API keys
3. Configurar en panel de administración
4. Probar conexión en modo sandbox

## 📊 Uso Básico

### Primer Uso
1. Registrar cuenta de usuario
2. Configurar perfil de riesgo
3. Conectar broker (modo sandbox)
4. Explorar academia gamificada
5. Realizar primeras operaciones simuladas

### Trading Simulado
1. Acceder al panel de órdenes
2. Seleccionar modo "Simulado"
3. Elegir ETF a operar
4. Configurar orden (cantidad, tipo)
5. Ejecutar y monitorear

### Comité Multi-IA
1. Activar IAs deseadas
2. Configurar pesos de votación
3. Establecer umbrales de confianza
4. Monitorear recomendaciones
5. Decidir seguir o ignorar señales

## 🧪 Testing

```bash
# Tests backend
cd backend
pytest tests/ -v

# Tests frontend
cd frontend
npm test

# Tests integración
docker-compose -f docker-compose.test.yml up
```

## 📈 Métricas y Monitoreo

- **Performance**: Latencia API, tiempo respuesta IA
- **Accuracy**: Precisión de predicciones IA
- **Usage**: Usuarios activos, operaciones realizadas
- **Security**: Intentos de acceso, logs de auditoría

## 🔒 Seguridad

### Mejores Prácticas
- Cambiar contraseñas por defecto
- Habilitar MFA
- Revisar logs regularmente
- Mantener API keys seguras
- Actualizar dependencias

### Auditoría
- Logs cifrados e inmutables
- Trazabilidad completa de operaciones
- Backup automático cifrado
- Monitoreo de accesos

## 🆘 Soporte y Troubleshooting

### Problemas Comunes
1. **Error de conexión broker**: Verificar API keys
2. **IA no responde**: Revisar recursos del sistema
3. **Datos no actualizan**: Verificar conexión internet
4. **Performance lenta**: Aumentar recursos asignados

### Logs
```bash
# Ver logs en tiempo real
docker-compose logs -f gestema-trading

# Logs específicos
tail -f data/logs/trading.log
tail -f data/logs/ia_committee.log
```

## 🤝 Contribución

### Para Desarrolladores
1. Fork del repositorio
2. Crear rama feature
3. Desarrollar y probar
4. Crear pull request
5. Revisión de código

### Desarrollo de Plugins
1. Usar plantilla base
2. Implementar interfaces requeridas
3. Crear plugin.yml
4. Probar en entorno local
5. Documentar funcionalidad

## 📄 Licencia

Aplicación gratuita e ilimitada para uso local.

---

**¿Necesitas ayuda?** Consulta la documentación completa en `/docs/` o contacta al equipo de desarrollo.