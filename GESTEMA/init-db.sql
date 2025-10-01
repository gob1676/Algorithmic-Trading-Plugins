-- GESTEMA - Inicialización de Base de Datos
-- Script para crear múltiples bases de datos en PostgreSQL

-- Crear base de datos para GESTEMA TRADING
CREATE DATABASE gestema_trading OWNER gestema;

-- Crear base de datos para GESTEMA ADMIN
CREATE DATABASE gestema_admin OWNER gestema_admin;

-- Conceder permisos
GRANT ALL PRIVILEGES ON DATABASE gestema_trading TO gestema;
GRANT ALL PRIVILEGES ON DATABASE gestema_admin TO gestema_admin;

-- Conectar a gestema_trading y crear extensiones
\c gestema_trading;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Conectar a gestema_admin y crear extensiones
\c gestema_admin;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";