# GESTEMA - Sistema de Trading Inteligente

## 🚀 Descripción General

GESTEMA es un ecosistema completo de trading compuesto por dos aplicaciones interconectadas:

- **GESTEMA TRADING**: Plataforma principal para supervisar, comprar y vender ETFs con ayuda de diversas IAs
- **GESTEMA ADMIN**: Aplicación de administración exclusiva para mantener, actualizar y supervisar el sistema

## 📁 Estructura del Proyecto

```
GESTEMA/
├── GESTEMA-Trading/            # Aplicación de trading Multi-IA
│   ├── frontend/               # React frontend
│   ├── backend/                # FastAPI backend
│   ├── ia_committee/           # Comité Multi-IA
│   ├── brokers/                # Integraciones con brokers
│   ├── plugins/                # Sistema de plugins
│   ├── docs/                   # Documentación
│   ├── config/                 # Configuraciones
│   ├── data/                   # Datos cifrados
│   ├── reports/                # Reportes generados
│   └── backup/                 # Respaldos
│
├── GESTEMA-Admin/              # Aplicación de administración
│   ├── frontend/               # React frontend admin
│   ├── backend/                # FastAPI backend admin
│   │   ├── auth/               # Autenticación admin
│   │   ├── staging/            # Entorno de pruebas
│   │   ├── updater/            # Gestor de actualizaciones
│   │   ├── ia_interpreter/     # IA intérprete de cambios
│   │   ├── ia_evaluator/       # IA evaluadora de riesgos
│   │   ├── ia_documenter/      # IA documentadora
│   │   ├── system_monitor/     # Monitor del sistema
│   │   └── logs/               # Logs de auditoría
│   ├── docs_admin/             # Documentación admin
│   └── config/                 # Configuraciones admin
│
└── global_docs/                # Documentación global
    └── roadmap.md              # Hoja de ruta
```

## 🎯 Características Principales

### GESTEMA TRADING
- **Dashboard ETFs**: Precios en tiempo real, gráficas, variaciones
- **Panel de Órdenes**: Manual, simulado, prueba realista, real y automático
- **Multi-IA Supervisora**: Comité de IAs predictivas, explicativas y optimizadoras
- **Gamificación Educativa**: XP, logros, escenarios históricos
- **Brokers Integrados**: Alpaca, Interactive Brokers, TD Ameritrade
- **Sistema de Plugins**: Extensibilidad total
- **Seguridad Avanzada**: Cifrado AES-256, MFA, logs inmutables

### GESTEMA ADMIN
- **Panel de Control Exclusivo**: Acceso restringido al administrador
- **Staging Environment**: Pruebas seguras antes de implementar cambios
- **IA Intérprete**: Interpreta órdenes del admin y genera cambios
- **Gestor de Actualizaciones**: Control de versiones y rollback automático
- **Monitor del Sistema**: Salud del sistema y recursos
- **Evaluador de Riesgos**: IA que advierte posibles problemas
- **Documentador Automático**: Changelog automático

## 🚦 Plan de Desarrollo por Fases

1. **Fase 1**: Estructura inicial ✅
2. **Fase 2**: Backend base Trading (FastAPI)
3. **Fase 3**: Frontend base Trading (React)
4. **Fase 4**: Sistema de usuarios Trading
5. **Fase 5**: Módulos Trading Simulado + Prueba Realista
6. **Fase 6**: Integración Brokers
7. **Fase 7**: Comité Multi-IA
8. **Fase 8**: Academia Gamificada
9. **Fase 9**: Sistema de Plugins
10. **Fase 10**: Backend Admin
11. **Fase 11**: Frontend Admin
12. **Fase 12**: IA intérprete de cambios
13. **Fase 13**: Staging + Gestor de Actualizaciones
14. **Fase 14**: Audit logs, rollback, versionado
15. **Fase 15**: IA evaluadora + documentadora
16. **Fase 16**: Seguridad avanzada + Dockerización

## 🔧 Requisitos del Sistema

- **OS**: Zorin OS (Ubuntu/Debian)
- **Python**: 3.9+
- **Node.js**: 18+
- **Docker**: 20.10+
- **RAM**: 8GB mínimo, 16GB recomendado
- **Almacenamiento**: 20GB libres

## 🛡️ Seguridad

- Almacenamiento local cifrado AES-256
- Autenticación bcrypt/argon2
- JWT + MFA opcional
- Keys API en vault local
- Logs firmados con hash
- Sin dependencias externas para datos sensibles

## 📄 Licencia

Aplicación gratuita e ilimitada para uso local.

---

**Desarrollado para Zorin OS con amor ❤️**