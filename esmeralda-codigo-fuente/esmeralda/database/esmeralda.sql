-- =============================================================
-- Base de datos: Escuela de Fútbol La Esmeralda (Maracay, Venezuela)
-- Compatible con MySQL 5.7+ y MariaDB 10.2+
-- Importar en phpMyAdmin o con: mysql -u root -p < esmeralda.sql
-- =============================================================

CREATE DATABASE IF NOT EXISTS esmeralda
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE esmeralda;
SET NAMES utf8mb4;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS bitacora;
DROP TABLE IF EXISTS jugadores;
DROP TABLE IF EXISTS representantes;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS usuarios;
SET FOREIGN_KEY_CHECKS = 1;

-- -------------------------------------------------------------
-- Usuarios del sistema
-- -------------------------------------------------------------
CREATE TABLE usuarios (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre      VARCHAR(100) NOT NULL,
  usuario     VARCHAR(50)  NOT NULL UNIQUE,
  clave       VARCHAR(255) NOT NULL,
  rol         ENUM('administrador','secretaria','entrenador') NOT NULL DEFAULT 'secretaria',
  activo      TINYINT(1) NOT NULL DEFAULT 1,
  creado_en   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- -------------------------------------------------------------
-- Categorías (por edad deportiva = año actual - año de nacimiento)
-- -------------------------------------------------------------
CREATE TABLE categorias (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre      VARCHAR(30)  NOT NULL UNIQUE,
  edad_min    TINYINT UNSIGNED NOT NULL,
  edad_max    TINYINT UNSIGNED NOT NULL,
  horario     VARCHAR(120) NULL,
  entrenador  VARCHAR(100) NULL,
  descripcion VARCHAR(255) NULL
) ENGINE=InnoDB;

-- -------------------------------------------------------------
-- Representantes
-- -------------------------------------------------------------
CREATE TABLE representantes (
  id           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  cedula       VARCHAR(15)  NOT NULL UNIQUE,
  nombres      VARCHAR(80)  NOT NULL,
  apellidos    VARCHAR(80)  NOT NULL,
  parentesco   VARCHAR(30)  NOT NULL DEFAULT 'Madre',
  telefono     VARCHAR(20)  NOT NULL,
  telefono_alt VARCHAR(20)  NULL,
  correo       VARCHAR(120) NULL,
  direccion    VARCHAR(255) NULL,
  ocupacion    VARCHAR(80)  NULL,
  creado_en    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- -------------------------------------------------------------
-- Jugadores
-- -------------------------------------------------------------
CREATE TABLE jugadores (
  id                    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  cedula                VARCHAR(20)  NULL UNIQUE COMMENT 'Cédula o cédula escolar',
  nombres               VARCHAR(80)  NOT NULL,
  apellidos             VARCHAR(80)  NOT NULL,
  fecha_nacimiento      DATE         NOT NULL,
  sexo                  ENUM('M','F') NOT NULL,
  lugar_nacimiento      VARCHAR(100) NULL,
  direccion             VARCHAR(255) NULL,
  telefono              VARCHAR(20)  NULL,
  institucion_educativa VARCHAR(120) NULL,
  grado                 VARCHAR(30)  NULL,
  posicion              ENUM('Portero','Defensa','Mediocampista','Delantero','Por definir') NOT NULL DEFAULT 'Por definir',
  pie_dominante         ENUM('Derecho','Izquierdo','Ambos') NOT NULL DEFAULT 'Derecho',
  numero_camiseta       TINYINT UNSIGNED NULL,
  talla_camisa          VARCHAR(5)   NULL,
  tipo_sangre           ENUM('A+','A-','B+','B-','AB+','AB-','O+','O-','No sabe') NOT NULL DEFAULT 'No sabe',
  alergias              VARCHAR(255) NULL,
  condicion_medica      VARCHAR(255) NULL,
  peso                  DECIMAL(5,2) NULL COMMENT 'kg',
  estatura              DECIMAL(4,2) NULL COMMENT 'metros',
  foto                  VARCHAR(120) NULL,
  categoria_id          INT UNSIGNED NULL,
  representante_id      INT UNSIGNED NULL,
  fecha_inscripcion     DATE NOT NULL,
  estado                ENUM('activo','inactivo','retirado','lesionado') NOT NULL DEFAULT 'activo',
  observaciones         TEXT NULL,
  creado_por            INT UNSIGNED NULL,
  creado_en             DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  actualizado_en        DATETIME NULL ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_jug_categoria     FOREIGN KEY (categoria_id)     REFERENCES categorias(id)     ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_jug_representante FOREIGN KEY (representante_id) REFERENCES representantes(id) ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_jug_usuario       FOREIGN KEY (creado_por)       REFERENCES usuarios(id)       ON UPDATE CASCADE ON DELETE SET NULL,
  INDEX idx_jug_nombre (apellidos, nombres),
  INDEX idx_jug_estado (estado)
) ENGINE=InnoDB;

-- -------------------------------------------------------------
-- Bitácora de acciones
-- -------------------------------------------------------------
CREATE TABLE bitacora (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  usuario_id  INT UNSIGNED NULL,
  accion      VARCHAR(40)  NOT NULL,
  detalle     VARCHAR(255) NULL,
  fecha       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_bit_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON UPDATE CASCADE ON DELETE SET NULL,
  INDEX idx_bit_fecha (fecha)
) ENGINE=InnoDB;

-- =============================================================
-- Datos iniciales
-- =============================================================

-- Usuario administrador inicial:  usuario = admin   clave = Esmeralda2026
-- ¡Cambie esta clave al primer ingreso!
INSERT INTO usuarios (nombre, usuario, clave, rol) VALUES
('Administrador del Sistema', 'admin', '$2y$12$0DUdgSaItu7ajtyecP0UiOPL0XKWIswM.irj/NqzFPSbde2NlWLeW', 'administrador');

-- Categorías sugeridas (modificables desde el sistema)
INSERT INTO categorias (nombre, edad_min, edad_max, horario, descripcion) VALUES
('Sub-6',  4,  5,  'Sábados 8:00 a.m.',          'Iniciación / baby fútbol'),
('Sub-8',  6,  7,  'Mar y Jue 3:00 p.m.',        'Pre-infantil'),
('Sub-10', 8,  9,  'Mar y Jue 4:00 p.m.',        'Infantil A'),
('Sub-12', 10, 11, 'Lun, Mié y Vie 3:00 p.m.',   'Infantil B'),
('Sub-14', 12, 13, 'Lun, Mié y Vie 4:00 p.m.',   'Pre-juvenil'),
('Sub-16', 14, 15, 'Lun, Mié y Vie 5:00 p.m.',   'Juvenil A'),
('Sub-18', 16, 17, 'Lun, Mié y Vie 5:00 p.m.',   'Juvenil B');
