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
('Sub-18', 16, 17, 'Lun, Mié y Vie 5:00 p.m.',   'Juvenil B'),
('Sub-20', 18, 19, 'Lun, Mié y Vie 5:00 p.m.',   'Juvenil C');

-- Representantes con cédula registrada en la nómina al 03/11/2026 (completar nombre y teléfono desde el sistema)
INSERT INTO representantes (cedula, nombres, apellidos, parentesco, telefono) VALUES
('V-27262207', 'Representante', 'Carrillo Bravo', 'Otro', 'Por completar'),
('V-29628487', 'Representante', 'Vilera Medina', 'Otro', 'Por completar'),
('V-23792018', 'Representante', 'Lopez Alvarado', 'Otro', 'Por completar'),
('V-16206823', 'Representante', 'Bolivar Linarez', 'Otro', 'Por completar'),
('V-16224276', 'Representante', 'Rivero Pulido', 'Otro', 'Por completar'),
('V-23790304', 'Representante', 'Gomez Rengifo', 'Otro', 'Por completar'),
('V-14470903', 'Representante', 'Velasco Gonzalez', 'Otro', 'Por completar'),
('V-18489698', 'Representante', 'Hernandez Robinson', 'Otro', 'Por completar'),
('V-20108445', 'Representante', 'Nuñez Naranjo', 'Otro', 'Por completar'),
('V-30012477', 'Representante', 'Lopez Castro', 'Otro', 'Por completar'),
('V-16033578', 'Representante', 'Perez Pirela', 'Otro', 'Por completar'),
('V-18177442', 'Representante', 'Requena Salazar', 'Otro', 'Por completar'),
('V-19790104', 'Representante', 'Burgos Tovar', 'Otro', 'Por completar'),
('V-24815836', 'Representante', 'Velasquez Vargas', 'Otro', 'Por completar'),
('V-14962676', 'Representante', 'Serrano Landaeta', 'Otro', 'Por completar'),
('V-20109009', 'Representante', 'Rivas Montiel', 'Otro', 'Por completar'),
('V-19790045', 'Representante', 'Vargas Garcia', 'Otro', 'Por completar'),
('V-14490615', 'Representante', 'Arnao Velasquez', 'Otro', 'Por completar'),
('V-14010907', 'Representante', 'Galviz Urbaneja', 'Otro', 'Por completar'),
('V-23797294', 'Representante', 'Flores Barboza', 'Otro', 'Por completar');

-- Nómina de atletas activos al 03/11/2026 (120 jugadores)
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por) VALUES
(NULL, 'Aliex Mariano', 'Carrillo Bravo', '2020-06-09', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-8' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-27262207' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
(NULL, 'Christian Javier', 'Vilera Medina', '2019-11-30', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-8' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-29628487' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
(NULL, 'Abraham Moises', 'Lopez Alvarado', '2019-01-30', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-8' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-23792018' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
(NULL, 'Luis Jose', 'Bolivar Linarez', '2019-03-23', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-8' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-16206823' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
(NULL, 'Jose Martin', 'Rivero Pulido', '2019-09-29', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-8' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-16224276' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
(NULL, 'Mia Gimena', 'Gomez Rengifo', '2019-06-16', 'F', (SELECT id FROM categorias WHERE nombre = 'Sub-8' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-23790304' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
(NULL, 'Eduardo Jose', 'Velasco Gonzalez', '2018-05-25', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-14470903' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
(NULL, 'Neythan Gael', 'Hernandez Robinson', '2018-04-23', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-18489698' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
(NULL, 'Isaac Alexander', 'Nuñez Naranjo', '2018-04-09', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-20108445' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
(NULL, 'Eduard Mathias', 'Lopez Castro', '2018-10-27', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-30012477' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
(NULL, 'Luis Enmanuel', 'Perez Pirela', '2018-02-24', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-16033578' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
(NULL, 'Santiago Alexander', 'Requena Salazar', '2018-05-24', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-18177442' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
(NULL, 'Khaled Galileo', 'Burgos Tovar', '2018-06-21', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-19790104' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
(NULL, 'Mathias Josue', 'Velasquez Vargas', '2018-06-16', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-24815836' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
(NULL, 'Manuel Abraham', 'Serrano Landaeta', '2018-05-14', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-14962676' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-37691394', 'Eduardo Adyael', 'Blanco Villegas', '2017-02-18', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-37683237', 'Justin Gabriel', 'Montejo Trejo', '2017-03-19', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-37595018', 'Juan Miguel', 'Uzcategui Gallardo', '2017-01-07', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
(NULL, 'Sebastian Alejandro', 'Rivas Montiel', '2017-08-28', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-20109009' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-37809056', 'Andres Guillermo', 'Vasquez Guape', '2017-06-05', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
(NULL, 'Gael Santiago', 'Vargas Garcia', '2017-09-14', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-19790045' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-37597683', 'Brayner Daniel', 'Gonzalez Dale', '2017-01-07', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
(NULL, 'Victor Williangel', 'Arnao Velasquez', '2017-11-16', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-14490615' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
(NULL, 'Edward Aaron', 'Galviz Urbaneja', '2017-03-04', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-14010907' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-37570114', 'Angel Lenin', 'Delgado Alvarez', '2017-01-13', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-37868205', 'Lionel Mathias', 'Carrasquilla Salcedo', '2017-03-26', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
(NULL, 'Heidkeer Jesus', 'Flores Barboza', '2017-05-04', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-23797294' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-37002589', 'Cristian David', 'Rodriguez Cabeza', '2016-02-17', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-37255522', 'Xavier Andres', 'Rey Mijares', '2016-02-09', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-37655984', 'Deiver Mathias', 'Montero Diaz', '2016-02-17', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-37493237', 'Kendry Jesus', 'Vasquez Montilla', '2016-07-29', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-37494980', 'Ronald Rodolfo', 'Montilla Velasquez', '2016-10-29', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-37752903', 'Dylan Isaac', 'Faneite Chirino', '2016-08-24', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-37865391', 'Adrian Sabiel', 'Martinez Pariata', '2016-10-05', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-37935527', 'Santiago Jose', 'Franco Palencia', '2016-10-28', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-37293900', 'Jesneyker Enmanuel', 'Tovar Rojas', '2016-01-13', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
(NULL, 'Gabriel Matias', 'Gomez Rengifo', '2016-07-04', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-23790304' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36689853', 'Sebastián Alexander', 'Gerez Martin', '2015-06-11', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-37739023', 'Mathias Anthuan', 'Rondón Martinez', '2015-09-23', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36855468', 'Yander de Jesus', 'Villegas Hernandez', '2015-09-22', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36890103', 'Dylan Santiago', 'Rivas Montiel', '2015-11-12', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36708757', 'Fabian Alejandro', 'Alaes Salazar', '2015-10-06', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-37615554', 'Aran Israel', 'Rojas Bonilla', '2015-12-23', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-37328783', 'Arantxa Paola', 'Quintero Ortiz', '2015-05-30', 'F', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36710452', 'Samuel Andres', 'Martinez Rodriguez', '2015-05-26', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-37821571', 'Santiago Miguel Angel', 'Querales Garcia', '2015-07-29', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-37713057', 'Jhosua Yacniel', 'Parra Alfonzo', '2016-08-18', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36599999', 'Carlos Adrian', 'Marcano Ruiz', '2014-01-01', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36505392', 'Edoardo Andres', 'Hernandez Serna', '2014-09-12', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36774690', 'Willian Gabriel', 'Sierra Molina', '2014-11-13', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36774691', 'Williangel Daniel', 'Sierra Molina', '2014-11-13', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36653098', 'Handrius Francisco', 'Higuera Romero', '2014-11-08', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36031860', 'Luis Angel', 'Ramirez Zambrano', '2014-01-10', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36800857', 'Luis Manuel', 'Rodriguez Diaz', '2014-02-05', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-37615660', 'Aaron Jhonathan', 'Rojas Bonilla', '2014-09-03', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36226587', 'Alexis Andres', 'Pineda Gonzalez', '2014-07-11', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-35125749', 'Carlos Jose', 'Barreto Henriquez', '2013-01-17', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36387700', 'Liam Alejandro', 'Muñoz Alvarez', '2013-11-13', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-34707610', 'Cristian David', 'Beroes Mota', '2013-03-27', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-34676314', 'Fabian Alexis', 'Torres Carpio', '2013-01-24', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36419294', 'Yeiden Rogniel', 'Piña Peralta', '2013-07-25', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36007460', 'Jesús Adrian', 'Vargas Colmenares', '2013-04-24', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36042919', 'Jose Leonardo', 'Terán Zerpa', '2013-09-17', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-35025244', 'Emilio Enrique', 'Contreras Higuera', '2013-12-27', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36128370', 'Deisner Jadiel', 'Galeno Pinto', '2013-05-20', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-35108330', 'Jose Daniel', 'Adames Linares', '2013-05-30', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-35075586', 'Aaron Sebastian', 'Landaeta Cartaya', '2013-07-04', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36259889', 'Joaquin Santiago', 'Perez Ruiz', '2013-12-04', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36011219', 'Said Alejandro', 'Paez Rodriguez', '2013-01-02', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-35024995', 'Andres Jose', 'Bravo Barrios', '2013-04-27', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36320668', 'Angel Josue', 'España Perez', '2013-10-22', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36403901', 'Santiago Yuniel', 'Gonzalez Garcia', '2013-09-11', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36402362', 'Hector Alfonso', 'Drada Sivira', '2013-07-16', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36189335', 'Jonathan Santiago', 'Diaz Gonzalez', '2013-02-04', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36032112', 'Joseph Abraham', 'Noguera Mantilla', '2013-03-31', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36863287', 'Thiago Antonio', 'Chuello Correia', '2013-12-14', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36145186', 'Dylan Santiago', 'Vivas Castillo', '2013-06-25', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-35153113', 'Adrian Jose', 'Fuentes Villa', '2013-09-30', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36765975', 'Jonatan Gabriel', 'Peña Pinto', '2013-09-06', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-34371601', 'Juan José', 'Pérez Rojas', '2012-03-09', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-34332519', 'Jean Pierre Jessua', 'Cardozo Concepcion', '2012-01-18', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36198849', 'Sebastián Gabriel', 'Cabrera Rodriguez', '2012-05-02', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-34332484', 'Greyder Sebastián', 'Gonzalez Contreras', '2012-03-18', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-34707376', 'Jesus Alejandro', 'Pineda Gonzalez', '2012-12-10', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36339333', 'Andres Otoniel', 'Rumbos Nogales', '2012-12-19', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-34443644', 'Santiago Jhosuet', 'Velasquez Gonzalez', '2012-10-21', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-34477778', 'Jesus Ignacio', 'Jaspe Gutierrez', '2012-09-03', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36775112', 'Sebastian Enrique', 'Garcia Corona', '2012-11-17', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36118252', 'Allam Isaac', 'Bravo Perez', '2012-12-19', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36482817', 'Daniel Eduardo', 'Parra Nogales', '2011-03-09', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-34424872', 'Cesar Alessandro', 'Benitez Restuccia', '2011-06-17', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-34203381', 'Alejandro Ire', 'Sanabria Gonzalez', '2011-06-06', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-34464900', 'Robert Gabriel', 'Aular Paez', '2011-11-17', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-34443769', 'Abraham Rafael', 'Loreto Camacho', '2011-04-26', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-34852353', 'Alejandro Daniel', 'Rivas Freitez', '2011-12-02', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-33958258', 'Santiago David', 'Valencia Ramirez', '2011-03-06', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36185191', 'Andres Antonio', 'Madero Mejias', '2011-04-25', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-34637215', 'Santiago Jesus', 'Briceño Madera', '2011-08-03', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36053703', 'Isaac Alexander', 'Rojas Bonilla', '2011-10-20', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36032444', 'Yasniel Gradyel', 'Benavides Peña', '2011-02-05', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-34182747', 'Arturo Luis', 'Pinto Lara', '2011-03-27', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-33709230', 'Alexander Antonio', 'Regalado Torrealba', '2011-01-20', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-36185491', 'Jetsuan Lee', 'Terán Avendaño', '2011-08-02', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-34519832', 'Giovanni Andres', 'Lopez Rico', '2011-11-17', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-33550086', 'Wilmer David', 'Pereira Peñaloza', '2010-08-13', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-18' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-34938291', 'Jose Diego', 'Magdaleno Vasquez', '2010-03-13', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-18' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-33770213', 'Valeria Andrea', 'Uzcategui Gallardo', '2010-11-15', 'F', (SELECT id FROM categorias WHERE nombre = 'Sub-18' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-34335902', 'Jean Jeremias', 'Jimenez Milano', '2010-09-06', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-18' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-34332311', 'Paolo Gabrielle', 'Colicchia Caggiano', '2010-05-18', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-18' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-34644568', 'Cesar Armando', 'Montesinos Parra', '2010-07-16', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-18' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-33721706', 'Jose Miguel', 'Mendez Berroteran', '2010-10-08', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-18' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-37102819', 'Yeiner Ezequiel', 'Cedeño Tejeda', '2010-08-21', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-18' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-33300008', 'Rayber Alejandro', 'Avila Carriillo', '2010-02-03', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-18' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-33183128', 'Luis Andres', 'Hernandez Serna', '2009-11-04', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-18' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-35125498', 'Jeremia Federico', 'Jansasoy Chamorro', '2009-09-06', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-18' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-34303836', 'Eithan Emir', 'Morillo Diaz', '2009-11-18', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-18' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-32718857', 'Freddy Giovanny', 'Castellano Flores', '2008-11-18', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-18' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-33732754', 'Samuel Eduardo', 'Bolivar Peñaloza', '2009-10-05', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-18' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-32871478', 'Omar Daniel', 'Ramirez Piña', '2008-10-19', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-20' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1),
('V-32719044', 'Leinner Xavier', 'Lares Gomez', '2008-10-24', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-20' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', 1);
