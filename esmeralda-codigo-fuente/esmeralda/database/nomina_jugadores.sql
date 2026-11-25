-- =============================================================
-- Nómina de atletas activos al 03/11/2026 (120 jugadores)
-- Escuela Comunitaria de Fútbol "La Esmeralda" — RIF: J-50656527-7
-- Script seguro e idempotente para bases de datos existentes:
-- no borra tablas ni duplica jugadores ya registrados.
-- Uso: mysql -u root -p esmeralda < nomina_jugadores.sql
-- =============================================================

USE esmeralda;
SET NAMES utf8mb4;

-- Asegurar que exista la categoría Sub-20
INSERT IGNORE INTO categorias (nombre, edad_min, edad_max, horario, descripcion) VALUES
('Sub-20', 18, 19, 'Lun, Mié y Vie 5:00 p.m.', 'Juvenil C');

-- Representantes con cédula registrada en la nómina (datos por completar)
INSERT IGNORE INTO representantes (cedula, nombres, apellidos, parentesco, telefono) VALUES
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

-- Jugadores activos (120 atletas)
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT NULL, 'Aliex Mariano', 'Carrillo Bravo', '2020-06-09', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-8' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-27262207' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE nombres = 'Aliex Mariano' AND apellidos = 'Carrillo Bravo' AND fecha_nacimiento = '2020-06-09');
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT NULL, 'Christian Javier', 'Vilera Medina', '2019-11-30', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-8' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-29628487' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE nombres = 'Christian Javier' AND apellidos = 'Vilera Medina' AND fecha_nacimiento = '2019-11-30');
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT NULL, 'Abraham Moises', 'Lopez Alvarado', '2019-01-30', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-8' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-23792018' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE nombres = 'Abraham Moises' AND apellidos = 'Lopez Alvarado' AND fecha_nacimiento = '2019-01-30');
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT NULL, 'Luis Jose', 'Bolivar Linarez', '2019-03-23', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-8' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-16206823' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE nombres = 'Luis Jose' AND apellidos = 'Bolivar Linarez' AND fecha_nacimiento = '2019-03-23');
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT NULL, 'Jose Martin', 'Rivero Pulido', '2019-09-29', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-8' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-16224276' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE nombres = 'Jose Martin' AND apellidos = 'Rivero Pulido' AND fecha_nacimiento = '2019-09-29');
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT NULL, 'Mia Gimena', 'Gomez Rengifo', '2019-06-16', 'F', (SELECT id FROM categorias WHERE nombre = 'Sub-8' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-23790304' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE nombres = 'Mia Gimena' AND apellidos = 'Gomez Rengifo' AND fecha_nacimiento = '2019-06-16');
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT NULL, 'Eduardo Jose', 'Velasco Gonzalez', '2018-05-25', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-14470903' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE nombres = 'Eduardo Jose' AND apellidos = 'Velasco Gonzalez' AND fecha_nacimiento = '2018-05-25');
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT NULL, 'Neythan Gael', 'Hernandez Robinson', '2018-04-23', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-18489698' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE nombres = 'Neythan Gael' AND apellidos = 'Hernandez Robinson' AND fecha_nacimiento = '2018-04-23');
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT NULL, 'Isaac Alexander', 'Nuñez Naranjo', '2018-04-09', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-20108445' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE nombres = 'Isaac Alexander' AND apellidos = 'Nuñez Naranjo' AND fecha_nacimiento = '2018-04-09');
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT NULL, 'Eduard Mathias', 'Lopez Castro', '2018-10-27', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-30012477' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE nombres = 'Eduard Mathias' AND apellidos = 'Lopez Castro' AND fecha_nacimiento = '2018-10-27');
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT NULL, 'Luis Enmanuel', 'Perez Pirela', '2018-02-24', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-16033578' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE nombres = 'Luis Enmanuel' AND apellidos = 'Perez Pirela' AND fecha_nacimiento = '2018-02-24');
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT NULL, 'Santiago Alexander', 'Requena Salazar', '2018-05-24', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-18177442' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE nombres = 'Santiago Alexander' AND apellidos = 'Requena Salazar' AND fecha_nacimiento = '2018-05-24');
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT NULL, 'Khaled Galileo', 'Burgos Tovar', '2018-06-21', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-19790104' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE nombres = 'Khaled Galileo' AND apellidos = 'Burgos Tovar' AND fecha_nacimiento = '2018-06-21');
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT NULL, 'Mathias Josue', 'Velasquez Vargas', '2018-06-16', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-24815836' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE nombres = 'Mathias Josue' AND apellidos = 'Velasquez Vargas' AND fecha_nacimiento = '2018-06-16');
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT NULL, 'Manuel Abraham', 'Serrano Landaeta', '2018-05-14', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-14962676' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE nombres = 'Manuel Abraham' AND apellidos = 'Serrano Landaeta' AND fecha_nacimiento = '2018-05-14');
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-37691394', 'Eduardo Adyael', 'Blanco Villegas', '2017-02-18', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-37691394' OR (nombres = 'Eduardo Adyael' AND apellidos = 'Blanco Villegas' AND fecha_nacimiento = '2017-02-18'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-37683237', 'Justin Gabriel', 'Montejo Trejo', '2017-03-19', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-37683237' OR (nombres = 'Justin Gabriel' AND apellidos = 'Montejo Trejo' AND fecha_nacimiento = '2017-03-19'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-37595018', 'Juan Miguel', 'Uzcategui Gallardo', '2017-01-07', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-37595018' OR (nombres = 'Juan Miguel' AND apellidos = 'Uzcategui Gallardo' AND fecha_nacimiento = '2017-01-07'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT NULL, 'Sebastian Alejandro', 'Rivas Montiel', '2017-08-28', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-20109009' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE nombres = 'Sebastian Alejandro' AND apellidos = 'Rivas Montiel' AND fecha_nacimiento = '2017-08-28');
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-37809056', 'Andres Guillermo', 'Vasquez Guape', '2017-06-05', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-37809056' OR (nombres = 'Andres Guillermo' AND apellidos = 'Vasquez Guape' AND fecha_nacimiento = '2017-06-05'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT NULL, 'Gael Santiago', 'Vargas Garcia', '2017-09-14', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-19790045' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE nombres = 'Gael Santiago' AND apellidos = 'Vargas Garcia' AND fecha_nacimiento = '2017-09-14');
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-37597683', 'Brayner Daniel', 'Gonzalez Dale', '2017-01-07', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-37597683' OR (nombres = 'Brayner Daniel' AND apellidos = 'Gonzalez Dale' AND fecha_nacimiento = '2017-01-07'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT NULL, 'Victor Williangel', 'Arnao Velasquez', '2017-11-16', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-14490615' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE nombres = 'Victor Williangel' AND apellidos = 'Arnao Velasquez' AND fecha_nacimiento = '2017-11-16');
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT NULL, 'Edward Aaron', 'Galviz Urbaneja', '2017-03-04', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-14010907' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE nombres = 'Edward Aaron' AND apellidos = 'Galviz Urbaneja' AND fecha_nacimiento = '2017-03-04');
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-37570114', 'Angel Lenin', 'Delgado Alvarez', '2017-01-13', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-37570114' OR (nombres = 'Angel Lenin' AND apellidos = 'Delgado Alvarez' AND fecha_nacimiento = '2017-01-13'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-37868205', 'Lionel Mathias', 'Carrasquilla Salcedo', '2017-03-26', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-37868205' OR (nombres = 'Lionel Mathias' AND apellidos = 'Carrasquilla Salcedo' AND fecha_nacimiento = '2017-03-26'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT NULL, 'Heidkeer Jesus', 'Flores Barboza', '2017-05-04', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-10' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-23797294' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE nombres = 'Heidkeer Jesus' AND apellidos = 'Flores Barboza' AND fecha_nacimiento = '2017-05-04');
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-37002589', 'Cristian David', 'Rodriguez Cabeza', '2016-02-17', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-37002589' OR (nombres = 'Cristian David' AND apellidos = 'Rodriguez Cabeza' AND fecha_nacimiento = '2016-02-17'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-37255522', 'Xavier Andres', 'Rey Mijares', '2016-02-09', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-37255522' OR (nombres = 'Xavier Andres' AND apellidos = 'Rey Mijares' AND fecha_nacimiento = '2016-02-09'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-37655984', 'Deiver Mathias', 'Montero Diaz', '2016-02-17', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-37655984' OR (nombres = 'Deiver Mathias' AND apellidos = 'Montero Diaz' AND fecha_nacimiento = '2016-02-17'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-37493237', 'Kendry Jesus', 'Vasquez Montilla', '2016-07-29', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-37493237' OR (nombres = 'Kendry Jesus' AND apellidos = 'Vasquez Montilla' AND fecha_nacimiento = '2016-07-29'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-37494980', 'Ronald Rodolfo', 'Montilla Velasquez', '2016-10-29', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-37494980' OR (nombres = 'Ronald Rodolfo' AND apellidos = 'Montilla Velasquez' AND fecha_nacimiento = '2016-10-29'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-37752903', 'Dylan Isaac', 'Faneite Chirino', '2016-08-24', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-37752903' OR (nombres = 'Dylan Isaac' AND apellidos = 'Faneite Chirino' AND fecha_nacimiento = '2016-08-24'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-37865391', 'Adrian Sabiel', 'Martinez Pariata', '2016-10-05', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-37865391' OR (nombres = 'Adrian Sabiel' AND apellidos = 'Martinez Pariata' AND fecha_nacimiento = '2016-10-05'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-37935527', 'Santiago Jose', 'Franco Palencia', '2016-10-28', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-37935527' OR (nombres = 'Santiago Jose' AND apellidos = 'Franco Palencia' AND fecha_nacimiento = '2016-10-28'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-37293900', 'Jesneyker Enmanuel', 'Tovar Rojas', '2016-01-13', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-37293900' OR (nombres = 'Jesneyker Enmanuel' AND apellidos = 'Tovar Rojas' AND fecha_nacimiento = '2016-01-13'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT NULL, 'Gabriel Matias', 'Gomez Rengifo', '2016-07-04', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), (SELECT id FROM representantes WHERE cedula = 'V-23790304' LIMIT 1), '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE nombres = 'Gabriel Matias' AND apellidos = 'Gomez Rengifo' AND fecha_nacimiento = '2016-07-04');
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36689853', 'Sebastián Alexander', 'Gerez Martin', '2015-06-11', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36689853' OR (nombres = 'Sebastián Alexander' AND apellidos = 'Gerez Martin' AND fecha_nacimiento = '2015-06-11'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-37739023', 'Mathias Anthuan', 'Rondón Martinez', '2015-09-23', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-37739023' OR (nombres = 'Mathias Anthuan' AND apellidos = 'Rondón Martinez' AND fecha_nacimiento = '2015-09-23'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36855468', 'Yander de Jesus', 'Villegas Hernandez', '2015-09-22', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36855468' OR (nombres = 'Yander de Jesus' AND apellidos = 'Villegas Hernandez' AND fecha_nacimiento = '2015-09-22'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36890103', 'Dylan Santiago', 'Rivas Montiel', '2015-11-12', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36890103' OR (nombres = 'Dylan Santiago' AND apellidos = 'Rivas Montiel' AND fecha_nacimiento = '2015-11-12'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36708757', 'Fabian Alejandro', 'Alaes Salazar', '2015-10-06', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36708757' OR (nombres = 'Fabian Alejandro' AND apellidos = 'Alaes Salazar' AND fecha_nacimiento = '2015-10-06'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-37615554', 'Aran Israel', 'Rojas Bonilla', '2015-12-23', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-37615554' OR (nombres = 'Aran Israel' AND apellidos = 'Rojas Bonilla' AND fecha_nacimiento = '2015-12-23'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-37328783', 'Arantxa Paola', 'Quintero Ortiz', '2015-05-30', 'F', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-37328783' OR (nombres = 'Arantxa Paola' AND apellidos = 'Quintero Ortiz' AND fecha_nacimiento = '2015-05-30'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36710452', 'Samuel Andres', 'Martinez Rodriguez', '2015-05-26', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36710452' OR (nombres = 'Samuel Andres' AND apellidos = 'Martinez Rodriguez' AND fecha_nacimiento = '2015-05-26'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-37821571', 'Santiago Miguel Angel', 'Querales Garcia', '2015-07-29', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-37821571' OR (nombres = 'Santiago Miguel Angel' AND apellidos = 'Querales Garcia' AND fecha_nacimiento = '2015-07-29'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-37713057', 'Jhosua Yacniel', 'Parra Alfonzo', '2016-08-18', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-12' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-37713057' OR (nombres = 'Jhosua Yacniel' AND apellidos = 'Parra Alfonzo' AND fecha_nacimiento = '2016-08-18'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36599999', 'Carlos Adrian', 'Marcano Ruiz', '2014-01-01', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36599999' OR (nombres = 'Carlos Adrian' AND apellidos = 'Marcano Ruiz' AND fecha_nacimiento = '2014-01-01'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36505392', 'Edoardo Andres', 'Hernandez Serna', '2014-09-12', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36505392' OR (nombres = 'Edoardo Andres' AND apellidos = 'Hernandez Serna' AND fecha_nacimiento = '2014-09-12'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36774690', 'Willian Gabriel', 'Sierra Molina', '2014-11-13', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36774690' OR (nombres = 'Willian Gabriel' AND apellidos = 'Sierra Molina' AND fecha_nacimiento = '2014-11-13'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36774691', 'Williangel Daniel', 'Sierra Molina', '2014-11-13', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36774691' OR (nombres = 'Williangel Daniel' AND apellidos = 'Sierra Molina' AND fecha_nacimiento = '2014-11-13'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36653098', 'Handrius Francisco', 'Higuera Romero', '2014-11-08', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36653098' OR (nombres = 'Handrius Francisco' AND apellidos = 'Higuera Romero' AND fecha_nacimiento = '2014-11-08'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36031860', 'Luis Angel', 'Ramirez Zambrano', '2014-01-10', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36031860' OR (nombres = 'Luis Angel' AND apellidos = 'Ramirez Zambrano' AND fecha_nacimiento = '2014-01-10'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36800857', 'Luis Manuel', 'Rodriguez Diaz', '2014-02-05', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36800857' OR (nombres = 'Luis Manuel' AND apellidos = 'Rodriguez Diaz' AND fecha_nacimiento = '2014-02-05'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-37615660', 'Aaron Jhonathan', 'Rojas Bonilla', '2014-09-03', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-37615660' OR (nombres = 'Aaron Jhonathan' AND apellidos = 'Rojas Bonilla' AND fecha_nacimiento = '2014-09-03'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36226587', 'Alexis Andres', 'Pineda Gonzalez', '2014-07-11', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36226587' OR (nombres = 'Alexis Andres' AND apellidos = 'Pineda Gonzalez' AND fecha_nacimiento = '2014-07-11'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-35125749', 'Carlos Jose', 'Barreto Henriquez', '2013-01-17', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-35125749' OR (nombres = 'Carlos Jose' AND apellidos = 'Barreto Henriquez' AND fecha_nacimiento = '2013-01-17'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36387700', 'Liam Alejandro', 'Muñoz Alvarez', '2013-11-13', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36387700' OR (nombres = 'Liam Alejandro' AND apellidos = 'Muñoz Alvarez' AND fecha_nacimiento = '2013-11-13'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-34707610', 'Cristian David', 'Beroes Mota', '2013-03-27', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-34707610' OR (nombres = 'Cristian David' AND apellidos = 'Beroes Mota' AND fecha_nacimiento = '2013-03-27'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-34676314', 'Fabian Alexis', 'Torres Carpio', '2013-01-24', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-34676314' OR (nombres = 'Fabian Alexis' AND apellidos = 'Torres Carpio' AND fecha_nacimiento = '2013-01-24'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36419294', 'Yeiden Rogniel', 'Piña Peralta', '2013-07-25', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36419294' OR (nombres = 'Yeiden Rogniel' AND apellidos = 'Piña Peralta' AND fecha_nacimiento = '2013-07-25'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36007460', 'Jesús Adrian', 'Vargas Colmenares', '2013-04-24', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36007460' OR (nombres = 'Jesús Adrian' AND apellidos = 'Vargas Colmenares' AND fecha_nacimiento = '2013-04-24'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36042919', 'Jose Leonardo', 'Terán Zerpa', '2013-09-17', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36042919' OR (nombres = 'Jose Leonardo' AND apellidos = 'Terán Zerpa' AND fecha_nacimiento = '2013-09-17'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-35025244', 'Emilio Enrique', 'Contreras Higuera', '2013-12-27', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-35025244' OR (nombres = 'Emilio Enrique' AND apellidos = 'Contreras Higuera' AND fecha_nacimiento = '2013-12-27'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36128370', 'Deisner Jadiel', 'Galeno Pinto', '2013-05-20', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36128370' OR (nombres = 'Deisner Jadiel' AND apellidos = 'Galeno Pinto' AND fecha_nacimiento = '2013-05-20'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-35108330', 'Jose Daniel', 'Adames Linares', '2013-05-30', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-35108330' OR (nombres = 'Jose Daniel' AND apellidos = 'Adames Linares' AND fecha_nacimiento = '2013-05-30'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-35075586', 'Aaron Sebastian', 'Landaeta Cartaya', '2013-07-04', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-35075586' OR (nombres = 'Aaron Sebastian' AND apellidos = 'Landaeta Cartaya' AND fecha_nacimiento = '2013-07-04'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36259889', 'Joaquin Santiago', 'Perez Ruiz', '2013-12-04', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36259889' OR (nombres = 'Joaquin Santiago' AND apellidos = 'Perez Ruiz' AND fecha_nacimiento = '2013-12-04'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36011219', 'Said Alejandro', 'Paez Rodriguez', '2013-01-02', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36011219' OR (nombres = 'Said Alejandro' AND apellidos = 'Paez Rodriguez' AND fecha_nacimiento = '2013-01-02'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-35024995', 'Andres Jose', 'Bravo Barrios', '2013-04-27', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-35024995' OR (nombres = 'Andres Jose' AND apellidos = 'Bravo Barrios' AND fecha_nacimiento = '2013-04-27'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36320668', 'Angel Josue', 'España Perez', '2013-10-22', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36320668' OR (nombres = 'Angel Josue' AND apellidos = 'España Perez' AND fecha_nacimiento = '2013-10-22'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36403901', 'Santiago Yuniel', 'Gonzalez Garcia', '2013-09-11', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36403901' OR (nombres = 'Santiago Yuniel' AND apellidos = 'Gonzalez Garcia' AND fecha_nacimiento = '2013-09-11'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36402362', 'Hector Alfonso', 'Drada Sivira', '2013-07-16', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36402362' OR (nombres = 'Hector Alfonso' AND apellidos = 'Drada Sivira' AND fecha_nacimiento = '2013-07-16'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36189335', 'Jonathan Santiago', 'Diaz Gonzalez', '2013-02-04', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36189335' OR (nombres = 'Jonathan Santiago' AND apellidos = 'Diaz Gonzalez' AND fecha_nacimiento = '2013-02-04'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36032112', 'Joseph Abraham', 'Noguera Mantilla', '2013-03-31', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36032112' OR (nombres = 'Joseph Abraham' AND apellidos = 'Noguera Mantilla' AND fecha_nacimiento = '2013-03-31'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36863287', 'Thiago Antonio', 'Chuello Correia', '2013-12-14', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36863287' OR (nombres = 'Thiago Antonio' AND apellidos = 'Chuello Correia' AND fecha_nacimiento = '2013-12-14'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36145186', 'Dylan Santiago', 'Vivas Castillo', '2013-06-25', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36145186' OR (nombres = 'Dylan Santiago' AND apellidos = 'Vivas Castillo' AND fecha_nacimiento = '2013-06-25'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-35153113', 'Adrian Jose', 'Fuentes Villa', '2013-09-30', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-35153113' OR (nombres = 'Adrian Jose' AND apellidos = 'Fuentes Villa' AND fecha_nacimiento = '2013-09-30'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36765975', 'Jonatan Gabriel', 'Peña Pinto', '2013-09-06', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-14' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36765975' OR (nombres = 'Jonatan Gabriel' AND apellidos = 'Peña Pinto' AND fecha_nacimiento = '2013-09-06'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-34371601', 'Juan José', 'Pérez Rojas', '2012-03-09', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-34371601' OR (nombres = 'Juan José' AND apellidos = 'Pérez Rojas' AND fecha_nacimiento = '2012-03-09'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-34332519', 'Jean Pierre Jessua', 'Cardozo Concepcion', '2012-01-18', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-34332519' OR (nombres = 'Jean Pierre Jessua' AND apellidos = 'Cardozo Concepcion' AND fecha_nacimiento = '2012-01-18'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36198849', 'Sebastián Gabriel', 'Cabrera Rodriguez', '2012-05-02', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36198849' OR (nombres = 'Sebastián Gabriel' AND apellidos = 'Cabrera Rodriguez' AND fecha_nacimiento = '2012-05-02'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-34332484', 'Greyder Sebastián', 'Gonzalez Contreras', '2012-03-18', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-34332484' OR (nombres = 'Greyder Sebastián' AND apellidos = 'Gonzalez Contreras' AND fecha_nacimiento = '2012-03-18'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-34707376', 'Jesus Alejandro', 'Pineda Gonzalez', '2012-12-10', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-34707376' OR (nombres = 'Jesus Alejandro' AND apellidos = 'Pineda Gonzalez' AND fecha_nacimiento = '2012-12-10'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36339333', 'Andres Otoniel', 'Rumbos Nogales', '2012-12-19', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36339333' OR (nombres = 'Andres Otoniel' AND apellidos = 'Rumbos Nogales' AND fecha_nacimiento = '2012-12-19'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-34443644', 'Santiago Jhosuet', 'Velasquez Gonzalez', '2012-10-21', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-34443644' OR (nombres = 'Santiago Jhosuet' AND apellidos = 'Velasquez Gonzalez' AND fecha_nacimiento = '2012-10-21'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-34477778', 'Jesus Ignacio', 'Jaspe Gutierrez', '2012-09-03', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-34477778' OR (nombres = 'Jesus Ignacio' AND apellidos = 'Jaspe Gutierrez' AND fecha_nacimiento = '2012-09-03'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36775112', 'Sebastian Enrique', 'Garcia Corona', '2012-11-17', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36775112' OR (nombres = 'Sebastian Enrique' AND apellidos = 'Garcia Corona' AND fecha_nacimiento = '2012-11-17'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36118252', 'Allam Isaac', 'Bravo Perez', '2012-12-19', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36118252' OR (nombres = 'Allam Isaac' AND apellidos = 'Bravo Perez' AND fecha_nacimiento = '2012-12-19'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36482817', 'Daniel Eduardo', 'Parra Nogales', '2011-03-09', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36482817' OR (nombres = 'Daniel Eduardo' AND apellidos = 'Parra Nogales' AND fecha_nacimiento = '2011-03-09'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-34424872', 'Cesar Alessandro', 'Benitez Restuccia', '2011-06-17', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-34424872' OR (nombres = 'Cesar Alessandro' AND apellidos = 'Benitez Restuccia' AND fecha_nacimiento = '2011-06-17'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-34203381', 'Alejandro Ire', 'Sanabria Gonzalez', '2011-06-06', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-34203381' OR (nombres = 'Alejandro Ire' AND apellidos = 'Sanabria Gonzalez' AND fecha_nacimiento = '2011-06-06'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-34464900', 'Robert Gabriel', 'Aular Paez', '2011-11-17', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-34464900' OR (nombres = 'Robert Gabriel' AND apellidos = 'Aular Paez' AND fecha_nacimiento = '2011-11-17'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-34443769', 'Abraham Rafael', 'Loreto Camacho', '2011-04-26', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-34443769' OR (nombres = 'Abraham Rafael' AND apellidos = 'Loreto Camacho' AND fecha_nacimiento = '2011-04-26'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-34852353', 'Alejandro Daniel', 'Rivas Freitez', '2011-12-02', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-34852353' OR (nombres = 'Alejandro Daniel' AND apellidos = 'Rivas Freitez' AND fecha_nacimiento = '2011-12-02'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-33958258', 'Santiago David', 'Valencia Ramirez', '2011-03-06', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-33958258' OR (nombres = 'Santiago David' AND apellidos = 'Valencia Ramirez' AND fecha_nacimiento = '2011-03-06'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36185191', 'Andres Antonio', 'Madero Mejias', '2011-04-25', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36185191' OR (nombres = 'Andres Antonio' AND apellidos = 'Madero Mejias' AND fecha_nacimiento = '2011-04-25'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-34637215', 'Santiago Jesus', 'Briceño Madera', '2011-08-03', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-34637215' OR (nombres = 'Santiago Jesus' AND apellidos = 'Briceño Madera' AND fecha_nacimiento = '2011-08-03'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36053703', 'Isaac Alexander', 'Rojas Bonilla', '2011-10-20', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36053703' OR (nombres = 'Isaac Alexander' AND apellidos = 'Rojas Bonilla' AND fecha_nacimiento = '2011-10-20'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36032444', 'Yasniel Gradyel', 'Benavides Peña', '2011-02-05', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36032444' OR (nombres = 'Yasniel Gradyel' AND apellidos = 'Benavides Peña' AND fecha_nacimiento = '2011-02-05'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-34182747', 'Arturo Luis', 'Pinto Lara', '2011-03-27', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-34182747' OR (nombres = 'Arturo Luis' AND apellidos = 'Pinto Lara' AND fecha_nacimiento = '2011-03-27'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-33709230', 'Alexander Antonio', 'Regalado Torrealba', '2011-01-20', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-33709230' OR (nombres = 'Alexander Antonio' AND apellidos = 'Regalado Torrealba' AND fecha_nacimiento = '2011-01-20'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-36185491', 'Jetsuan Lee', 'Terán Avendaño', '2011-08-02', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-36185491' OR (nombres = 'Jetsuan Lee' AND apellidos = 'Terán Avendaño' AND fecha_nacimiento = '2011-08-02'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-34519832', 'Giovanni Andres', 'Lopez Rico', '2011-11-17', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-16' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-34519832' OR (nombres = 'Giovanni Andres' AND apellidos = 'Lopez Rico' AND fecha_nacimiento = '2011-11-17'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-33550086', 'Wilmer David', 'Pereira Peñaloza', '2010-08-13', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-18' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-33550086' OR (nombres = 'Wilmer David' AND apellidos = 'Pereira Peñaloza' AND fecha_nacimiento = '2010-08-13'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-34938291', 'Jose Diego', 'Magdaleno Vasquez', '2010-03-13', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-18' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-34938291' OR (nombres = 'Jose Diego' AND apellidos = 'Magdaleno Vasquez' AND fecha_nacimiento = '2010-03-13'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-33770213', 'Valeria Andrea', 'Uzcategui Gallardo', '2010-11-15', 'F', (SELECT id FROM categorias WHERE nombre = 'Sub-18' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-33770213' OR (nombres = 'Valeria Andrea' AND apellidos = 'Uzcategui Gallardo' AND fecha_nacimiento = '2010-11-15'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-34335902', 'Jean Jeremias', 'Jimenez Milano', '2010-09-06', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-18' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-34335902' OR (nombres = 'Jean Jeremias' AND apellidos = 'Jimenez Milano' AND fecha_nacimiento = '2010-09-06'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-34332311', 'Paolo Gabrielle', 'Colicchia Caggiano', '2010-05-18', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-18' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-34332311' OR (nombres = 'Paolo Gabrielle' AND apellidos = 'Colicchia Caggiano' AND fecha_nacimiento = '2010-05-18'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-34644568', 'Cesar Armando', 'Montesinos Parra', '2010-07-16', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-18' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-34644568' OR (nombres = 'Cesar Armando' AND apellidos = 'Montesinos Parra' AND fecha_nacimiento = '2010-07-16'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-33721706', 'Jose Miguel', 'Mendez Berroteran', '2010-10-08', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-18' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-33721706' OR (nombres = 'Jose Miguel' AND apellidos = 'Mendez Berroteran' AND fecha_nacimiento = '2010-10-08'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-37102819', 'Yeiner Ezequiel', 'Cedeño Tejeda', '2010-08-21', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-18' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-37102819' OR (nombres = 'Yeiner Ezequiel' AND apellidos = 'Cedeño Tejeda' AND fecha_nacimiento = '2010-08-21'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-33300008', 'Rayber Alejandro', 'Avila Carriillo', '2010-02-03', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-18' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-33300008' OR (nombres = 'Rayber Alejandro' AND apellidos = 'Avila Carriillo' AND fecha_nacimiento = '2010-02-03'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-33183128', 'Luis Andres', 'Hernandez Serna', '2009-11-04', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-18' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-33183128' OR (nombres = 'Luis Andres' AND apellidos = 'Hernandez Serna' AND fecha_nacimiento = '2009-11-04'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-35125498', 'Jeremia Federico', 'Jansasoy Chamorro', '2009-09-06', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-18' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-35125498' OR (nombres = 'Jeremia Federico' AND apellidos = 'Jansasoy Chamorro' AND fecha_nacimiento = '2009-09-06'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-34303836', 'Eithan Emir', 'Morillo Diaz', '2009-11-18', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-18' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-34303836' OR (nombres = 'Eithan Emir' AND apellidos = 'Morillo Diaz' AND fecha_nacimiento = '2009-11-18'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-32718857', 'Freddy Giovanny', 'Castellano Flores', '2008-11-18', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-18' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-32718857' OR (nombres = 'Freddy Giovanny' AND apellidos = 'Castellano Flores' AND fecha_nacimiento = '2008-11-18'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-33732754', 'Samuel Eduardo', 'Bolivar Peñaloza', '2009-10-05', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-18' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-33732754' OR (nombres = 'Samuel Eduardo' AND apellidos = 'Bolivar Peñaloza' AND fecha_nacimiento = '2009-10-05'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-32871478', 'Omar Daniel', 'Ramirez Piña', '2008-10-19', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-20' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-32871478' OR (nombres = 'Omar Daniel' AND apellidos = 'Ramirez Piña' AND fecha_nacimiento = '2008-10-19'));
INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
SELECT 'V-32719044', 'Leinner Xavier', 'Lares Gomez', '2008-10-24', 'M', (SELECT id FROM categorias WHERE nombre = 'Sub-20' LIMIT 1), NULL, '2026-11-03', 'activo', 'Nómina de atletas activos al 03/11/2026', (SELECT id FROM usuarios WHERE usuario = 'admin' LIMIT 1)
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM jugadores WHERE cedula = 'V-32719044' OR (nombres = 'Leinner Xavier' AND apellidos = 'Lares Gomez' AND fecha_nacimiento = '2008-10-24'));
