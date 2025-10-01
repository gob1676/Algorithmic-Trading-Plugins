# GESTEMA ADMIN

## Descripción
Aplicación de administración y mantenimiento exclusiva para el creador de GESTEMA. Permite mantener, actualizar, modificar y supervisar GESTEMA TRADING y a sí misma, siempre con pruebas seguras antes de implementar cambios.

## Características Principales

### 🔐 Acceso Restringido
- Registro inicial de un único administrador
- Autenticación MFA obligatoria
- Vault de credenciales cifrado
- Logs de auditoría inmutables

### 🧪 Entorno de Staging
- Duplicado completo de GESTEMA TRADING
- Pruebas automáticas de cambios
- Validación de integridad
- Rollback automático en fallos

### 🤖 IA Intérprete de Cambios
- Interpreta órdenes del administrador
- Genera código automáticamente
- Valida cambios antes de aplicar
- Sugiere mejoras y optimizaciones

### 📊 Gestión de Actualizaciones
- Búsqueda automática de actualizaciones
- Creación de actualizaciones personalizadas
- Aplicación programada
- Notificaciones de estado

### 🔄 Control de Versiones
- Versionado automático
- Comparación de rendimiento
- Rollback granular
- Changelog generado por IA

### 📈 Monitoreo del Sistema
- Salud de recursos (CPU, RAM, GPU)
- Rendimiento de APIs
- Latencia de IA
- Alertas proactivas

### 📅 Programación
- Agenda de cambios
- Aplicación en horarios específicos
- Notificaciones programadas
- Mantenimiento automático

## Estructura del Proyecto

```
GESTEMA-Admin/
├── frontend/              # React + TypeScript
├── backend/
│   ├── auth/              # Autenticación admin
│   ├── staging/           # Entorno de pruebas
│   ├── updater/           # Gestor de actualizaciones
│   ├── ia_interpreter/    # IA que interpreta cambios
│   ├── ia_evaluator/      # IA que evalúa riesgos
│   ├── ia_documenter/     # IA documentadora
│   ├── system_monitor/    # Monitoreo de recursos
│   └── logs/              # Logs de auditoría
├── docs_admin/            # Documentación administrativa
└── config/                # Configuraciones
```

## Funcionalidades Detalladas

### 🎯 Localizador de Instalaciones
- Búsqueda automática de GESTEMA TRADING
- Detección de versiones instaladas
- Mapeo de configuraciones
- Estado de salud de instalaciones

### 🧠 Cuadro AI de Cambios
- **IA Intérprete**: Convierte órdenes en código
- **IA Evaluadora**: Analiza riesgos y estabilidad
- **IA Documentadora**: Genera changelog automático
- **IA Optimizadora**: Sugiere mejoras de rendimiento

### 🔍 Panel Comparativo
- Métricas antes/después de cambios
- Rendimiento de CPU, RAM, GPU
- Latencia de APIs y respuestas IA
- Análisis de estabilidad

### 🛡️ Evaluación de Riesgos
- Análisis de impacto en seguridad
- Detección de vulnerabilidades
- Validación de integridad
- Alertas de inestabilidad

### 📋 Gestión de Recursos
- Monitoreo en tiempo real
- Alertas de sobrecarga
- Optimización automática
- Limpieza de recursos

## Instalación

### Prerrequisitos
- GESTEMA TRADING instalado
- Python 3.11+
- Node.js 18+
- Acceso de administrador

### Instalación
```bash
# Clonar repositorio
git clone <repository-url>
cd GESTEMA-Admin

# Configuración inicial
chmod +x setup_admin.sh
./setup_admin.sh

# Crear administrador
python backend/auth/create_admin.py
```

## Uso

### Primera Configuración
1. Ejecutar `setup_admin.sh`
2. Crear cuenta de administrador
3. Configurar MFA
4. Localizar instalaciones de GESTEMA TRADING

### Gestión de Cambios
1. Ingresar orden de cambio
2. IA interpreta y genera código
3. Pruebas en staging
4. Evaluación de riesgos
5. Aprobación y aplicación

### Monitoreo
1. Dashboard de recursos
2. Alertas automáticas
3. Logs de auditoría
4. Reportes de rendimiento

## Comandos de IA

### Ejemplos de Órdenes
```
"Agregar indicador RSI al dashboard"
"Optimizar algoritmo de trading automático"
"Actualizar dependencias de seguridad"
"Crear nuevo plugin de análisis técnico"
"Mejorar rendimiento de consultas de base de datos"
```

### Respuesta de IA
- Generación de código
- Análisis de impacto
- Plan de implementación
- Estimación de tiempo
- Recursos necesarios

## Seguridad

### Autenticación
- Usuario único de administrador
- Contraseña bcrypt/argon2
- MFA obligatorio (TOTP)
- Sesiones con timeout

### Auditoría
- Logs cifrados e inmutables
- Firmas hash de cambios
- Trazabilidad completa
- Alertas de seguridad

### Vault
- Credenciales cifradas AES-256
- Rotación automática de claves
- Backup seguro
- Recuperación de emergencia

## API Administrativa

### Endpoints Principales
- `/admin/auth/` - Autenticación
- `/admin/staging/` - Gestión de staging
- `/admin/updates/` - Actualizaciones
- `/admin/monitor/` - Monitoreo
- `/admin/ai/` - Comandos de IA
- `/admin/audit/` - Logs de auditoría

## Desarrollo

### Estructura de Cambios
```json
{
  "id": "change_001",
  "type": "feature",
  "description": "Agregar indicador RSI",
  "target": "GESTEMA-Trading",
  "files": ["frontend/components/RSI.tsx"],
  "dependencies": ["ta-lib"],
  "tests": ["test_rsi_indicator.py"],
  "rollback": "remove_rsi_indicator.py"
}
```

### Flujo de Aplicación
1. **Interpretación**: IA convierte orden en código
2. **Validación**: Verificación de sintaxis y dependencias
3. **Staging**: Aplicación en entorno de prueba
4. **Testing**: Ejecución de tests automáticos
5. **Evaluación**: Análisis de riesgos y rendimiento
6. **Aprobación**: Confirmación del administrador
7. **Aplicación**: Implementación en producción
8. **Documentación**: Generación automática de changelog

## Licencia
Exclusiva para el creador de GESTEMA.

## Soporte
- Documentación: `/docs_admin/`
- Logs: `/backend/logs/`
- Monitoreo: Dashboard administrativo