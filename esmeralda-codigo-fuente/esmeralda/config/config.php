<?php
/**
 * Configuración general del sistema.
 *
 * Conexión a la base de datos, en este orden de prioridad:
 *   1. config/config.local.php  (opcional, sólo en tu equipo; no se sube a git).
 *      Úsalo para MAMP/XAMPP. Ver config/config.local.ejemplo.php
 *   2. Variables de entorno DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASS, DB_SOCKET.
 *   3. Los valores por defecto de abajo (en el VPS el instalador pone la clave real).
 */
if (is_file(__DIR__ . '/config.local.php')) {
    require __DIR__ . '/config.local.php';
}
defined('DB_HOST')   || define('DB_HOST', getenv('DB_HOST') ?: 'localhost');
defined('DB_PORT')   || define('DB_PORT', getenv('DB_PORT') ?: '3306');
defined('DB_NAME')   || define('DB_NAME', getenv('DB_NAME') ?: 'esmeralda');
defined('DB_USER')   || define('DB_USER', getenv('DB_USER') ?: 'root');
defined('DB_PASS')   || define('DB_PASS', getenv('DB_PASS') !== false ? getenv('DB_PASS') : '');
defined('DB_SOCKET') || define('DB_SOCKET', getenv('DB_SOCKET') ?: '');   // ej. MAMP: /Applications/MAMP/tmp/mysql/mysql.sock

define('APP_NOMBRE', 'Escuela de Fútbol La Esmeralda');
define('APP_SIGLAS', 'EF La Esmeralda');
define('APP_UBICACION', 'Municipio Girardot, Maracay, estado Aragua');

define('FOTO_MAX_BYTES', 2 * 1024 * 1024);   // 2 MB
define('FOTO_DIR', __DIR__ . '/../uploads/fotos/');
define('FOTO_URL', 'uploads/fotos/');

date_default_timezone_set('America/Caracas');
