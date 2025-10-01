# 🛠️ GESTEMA ADMIN

## 🎯 Descripción

GESTEMA ADMIN es la aplicación de administración exclusiva del ecosistema GESTEMA, diseñada para mantener, actualizar, modificar y supervisar tanto GESTEMA TRADING como a sí misma, garantizando siempre pruebas seguras antes de implementar cualquier cambio.

## ⚡ Características Principales

### 🔐 Acceso Exclusivo
- Registro inicial de un único administrador
- Autenticación con bcrypt + MFA obligatorio
- Sesiones seguras con JWT
- Logs de acceso inmutables

### 🎛️ Panel de Control Central
- **Localizador**: Busca manual/automáticamente instalación de GESTEMA TRADING
- **Monitor del Sistema**: CPU, RAM, GPU, contenedores Docker
- **Gestor de Recursos**: Salud del sistema en tiempo real
- **Dashboard de Métricas**: Rendimiento antes/después de cambios

### 🤖 Cuadro AI de Cambios
- Múltiples IAs interpretan órdenes del administrador
- Generación automática de cambios en staging
- Ejemplos de comandos:
  - "añadir indicador RSI"
  - "optimizar consultas de base de datos"
  - "actualizar modelo de IA predictiva"
  - "mejorar seguridad de autenticación"

### 🧪 Entorno Staging
- Duplicado completo de GESTEMA TRADING
- Pruebas seguras antes de producción
- Aislamiento total del entorno real
- Rollback automático en caso de fallo

### 📦 Gestor de Actualizaciones
- Búsqueda automática de actualizaciones
- Creación de actualizaciones personalizadas
- Sugerencias de IA para mejoras
- Selección de destino (ADMIN y/o TRADING)
- **Siempre primero en staging, luego producción**

### 🔄 Control de Versiones y Rollback
- Versionado automático de todos los cambios
- Rollback automático en caso de fallo
- Historial completo de modificaciones
- Puntos de restauración seguros

### 📊 Panel Comparativo
- Métricas de rendimiento antes/después
- Análisis de impacto de cambios
- Comparación de CPU, RAM, latencia API
- Performance de IAs y modelos

### ⏰ Agenda y Scheduler
- Programación de cambios aprobados
- Ventanas de mantenimiento
- Ejecución automática en horarios específicos
- Notificaciones de tareas programadas

### 🔔 Sistema de Notificaciones
- Avisos exclusivos al administrador
- Nuevas actualizaciones disponibles
- Fallos en pruebas de staging
- Alertas de seguridad y rendimiento
- Reportes de salud del sistema

### 🤖 IAs Especializadas

#### IA Evaluadora de Cambios
- Análisis de riesgos antes de aplicar cambios
- Detección de posibles inestabilidades
- Evaluación de impacto en seguridad
- Recomendaciones de precauciones

#### IA Documentadora Automática
- Changelog automático en `/docs/changelog.md`
- Documentación técnica auto-generada
- Descripción de cambios implementados
- Historial de decisiones y justificaciones

### 🔒 Auditoría y Seguridad
- Logs de auditoría cifrados e inmutables
- Trazabilidad completa de acciones
- Firma digital de cambios
- Backup automático antes de modificaciones

## 📁 Estructura del Proyecto

```
GESTEMA-Admin/
├── frontend/                   # React + TypeScript Admin
│   ├── src/
│   │   ├── components/         # Componentes admin
│   │   ├── pages/             # Páginas admin
│   │   ├── hooks/             # Custom hooks admin
│   │   ├── services/          # Servicios API admin
│   │   ├── store/             # Estado global admin
│   │   └── utils/             # Utilidades admin
│   └── package.json
│
├── backend/                    # FastAPI + Python Admin
│   ├── app/
│   │   ├── api/               # Endpoints API admin
│   │   ├── core/              # Configuración core admin
│   │   ├── models/            # Modelos admin
│   │   └── main.py            # Punto de entrada admin
│   │
│   ├── auth/                   # Autenticación admin
│   │   ├── models.py          # Modelo usuario admin
│   │   ├── routes.py          # Rutas autenticación
│   │   ├── security.py        # Seguridad y MFA
│   │   └── middleware.py      # Middleware auth
│   │
│   ├── staging/                # Entorno de pruebas
│   │   ├── manager.py         # Gestor staging
│   │   ├── docker_manager.py  # Gestión contenedores
│   │   ├── database_manager.py# Gestión BD staging
│   │   └── sync_manager.py    # Sincronización
│   │
│   ├── updater/                # Gestor actualizaciones
│   │   ├── update_manager.py  # Gestor principal
│   │   ├── version_control.py # Control versiones
│   │   ├── rollback_manager.py# Gestor rollback
│   │   └── scheduler.py       # Programador tareas
│   │
│   ├── ia_interpreter/         # IA intérprete cambios
│   │   ├── command_parser.py  # Parser comandos
│   │   ├── code_generator.py  # Generador código
│   │   ├── change_analyzer.py # Analizador cambios
│   │   └── models/            # Modelos IA
│   │
│   ├── ia_evaluator/           # IA evaluadora riesgos
│   │   ├── risk_analyzer.py   # Analizador riesgos
│   │   ├── security_checker.py# Checker seguridad
│   │   ├── stability_tester.py# Tester estabilidad
│   │   └── impact_assessor.py # Evaluador impacto
│   │
│   ├── ia_documenter/          # IA documentadora
│   │   ├── changelog_generator.py # Generador changelog
│   │   ├── doc_generator.py   # Generador docs
│   │   ├── summary_creator.py # Creador resúmenes
│   │   └── templates/         # Plantillas docs
│   │
│   ├── system_monitor/         # Monitor sistema
│   │   ├── resource_monitor.py# Monitor recursos
│   │   ├── health_checker.py  # Checker salud
│   │   ├── performance_tracker.py # Tracker performance
│   │   └── alert_manager.py   # Gestor alertas
│   │
│   └── logs/                   # Logs auditoría
│       ├── audit_logger.py    # Logger auditoría
│       ├── security_logger.py # Logger seguridad
│       └── encrypted_storage.py # Almacén cifrado
│
├── docs_admin/                 # Documentación admin
│   ├── installation.md        # Instalación admin
│   ├── user_guide.md          # Guía usuario admin
│   ├── api_reference.md       # Referencia API admin
│   └── security_guide.md      # Guía seguridad
│
├── config/                     # Configuraciones admin
│   ├── admin_settings.py      # Configuración admin
│   ├── staging_config.py      # Configuración staging
│   └── security_config.py     # Configuración seguridad
│
├── docker-compose.admin.yml    # Docker admin
├── Dockerfile.admin            # Imagen Docker admin
└── setup_admin.sh             # Script instalación admin
```

## 🚀 Instalación y Configuración

### Requisitos Previos
- GESTEMA TRADING instalado y funcionando
- Zorin OS (Ubuntu/Debian)
- Python 3.9+
- Node.js 18+
- Docker 20.10+
- 16GB RAM recomendado (para staging)

### Instalación
```bash
# Navegar al directorio admin
cd GESTEMA/GESTEMA-Admin

# Ejecutar script de instalación admin
chmod +x setup_admin.sh
./setup_admin.sh

# O usar Docker
docker-compose -f docker-compose.admin.yml up -d
```

### Configuración Inicial
```bash
# Crear usuario administrador inicial
python backend/scripts/create_admin.py

# Configurar MFA
python backend/scripts/setup_mfa.py

# Localizar GESTEMA TRADING
python backend/scripts/locate_trading.py
```

## 🔧 Configuración

### Variables de Entorno Admin
```bash
# .env.admin
ADMIN_DATABASE_URL=sqlite:///./data/admin.db
ADMIN_SECRET_KEY=your-admin-secret-key
TRADING_LOCATION=/path/to/GESTEMA-Trading
STAGING_LOCATION=/path/to/staging
MFA_REQUIRED=true
ENVIRONMENT=production
```

### Configuración de Staging
```bash
# Crear entorno staging
python backend/staging/setup_staging.py

# Sincronizar con producción
python backend/staging/sync_production.py
```

## 📊 Uso del Panel Admin

### Primer Acceso
1. Login con credenciales admin
2. Configurar MFA (obligatorio)
3. Localizar GESTEMA TRADING
4. Verificar entorno staging
5. Revisar métricas del sistema

### Aplicar Cambios con IA
1. Acceder al "Cuadro AI de Cambios"
2. Escribir comando en lenguaje natural:
   ```
   "Añadir indicador MACD al dashboard principal"
   "Optimizar consultas de la base de datos de usuarios"
   "Actualizar modelo LSTM con datos más recientes"
   ```
3. IA interpreta y genera cambios
4. Revisar cambios propuestos
5. Aplicar primero en staging
6. Probar funcionalidad
7. Aprobar para producción

### Gestión de Actualizaciones
1. **Búsqueda Automática**: Sistema busca actualizaciones
2. **Evaluación IA**: IA evalúa riesgos y beneficios
3. **Staging**: Aplicar en entorno de prueba
4. **Testing**: Ejecutar batería de pruebas
5. **Aprobación**: Revisar resultados y aprobar
6. **Programación**: Programar aplicación en producción
7. **Monitoreo**: Supervisar aplicación en vivo

### Monitor del Sistema
- **CPU**: Uso en tiempo real
- **RAM**: Memoria disponible/utilizada
- **GPU**: Uso para IAs (si disponible)
- **Docker**: Estado de contenedores
- **Red**: Latencia y throughput
- **Almacenamiento**: Espacio disponible

## 🤖 IAs Administrativas

### IA Intérprete de Cambios
```python
# Ejemplo de uso
interpreter = IAInterpreter()
command = "Añadir soporte para nuevo broker Fidelity"
changes = interpreter.interpret(command)
staging.apply_changes(changes)
```

### IA Evaluadora de Riesgos
```python
# Ejemplo de evaluación
evaluator = RiskEvaluator()
risk_report = evaluator.evaluate_changes(changes)
if risk_report.risk_level < 0.3:
    approve_changes()
```

### IA Documentadora
```python
# Generación automática de docs
documenter = AutoDocumenter()
documenter.generate_changelog(changes)
documenter.update_technical_docs()
```

## 🔒 Seguridad Admin

### Autenticación Multi-Factor
- TOTP (Google Authenticator, Authy)
- Backup codes de emergencia
- Renovación periódica de secretos

### Auditoría Completa
- Todos los accesos registrados
- Cambios trazables por usuario
- Logs cifrados e inmutables
- Firma digital de acciones críticas

### Backup y Recuperación
- Backup automático antes de cambios
- Puntos de restauración múltiples
- Recuperación granular por componente
- Verificación de integridad

## 📈 Métricas y Reportes

### Dashboard Principal
- Estado general del sistema
- Últimas actualizaciones aplicadas
- Métricas de rendimiento
- Alertas activas

### Reportes Automáticos
- Reporte semanal de salud del sistema
- Análisis mensual de cambios aplicados
- Reporte trimestral de seguridad
- Métricas anuales de rendimiento

## 🆘 Troubleshooting Admin

### Problemas Comunes
1. **Staging no sincroniza**: Verificar permisos y espacio
2. **IA no responde**: Revisar recursos GPU/CPU
3. **Rollback falla**: Verificar integridad de backups
4. **MFA no funciona**: Regenerar códigos de emergencia

### Recuperación de Emergencia
```bash
# Rollback de emergencia
python backend/scripts/emergency_rollback.py

# Restaurar desde backup
python backend/scripts/restore_backup.py --date=2025-10-01

# Reiniciar servicios
docker-compose -f docker-compose.admin.yml restart
```

## 🔄 Flujo de Trabajo Típico

1. **Monitoreo Continuo**: Sistema supervisa GESTEMA TRADING
2. **Detección de Necesidades**: IA sugiere mejoras o admin identifica necesidades
3. **Interpretación**: IA interpreta comandos y genera cambios
4. **Evaluación**: IA evaluadora analiza riesgos
5. **Staging**: Aplicación en entorno de prueba
6. **Testing**: Batería de pruebas automáticas
7. **Aprobación**: Admin revisa y aprueba
8. **Programación**: Scheduling para aplicación
9. **Aplicación**: Implementación en producción
10. **Monitoreo Post-Cambio**: Supervisión de impacto
11. **Documentación**: Actualización automática de docs

## 📄 Licencia

Aplicación administrativa gratuita e ilimitada para uso local exclusivo del administrador del sistema GESTEMA.

---

**⚠️ IMPORTANTE**: Esta aplicación está diseñada para uso exclusivo del administrador del sistema. El acceso no autorizado está estrictamente prohibido y será registrado en los logs de auditoría.