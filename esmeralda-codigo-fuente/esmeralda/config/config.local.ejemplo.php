<?php
/**
 * EJEMPLO de configuración local. Copie este archivo como config.local.php
 * (en esta misma carpeta) y ajuste los datos. config.local.php NO se sube a git.
 */

// --- MAMP (Mac): valores por defecto de MAMP ---
define('DB_SOCKET', '/Applications/MAMP/tmp/mysql/mysql.sock');
define('DB_NAME', 'esmeralda');
define('DB_USER', 'root');
define('DB_PASS', 'root');

// --- XAMPP (Windows/Mac): usar en lugar de lo anterior ---
// define('DB_HOST', '127.0.0.1');
// define('DB_PORT', '3306');
// define('DB_NAME', 'esmeralda');
// define('DB_USER', 'root');
// define('DB_PASS', '');
