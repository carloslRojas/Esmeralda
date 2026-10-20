<?php
/**
 * Arranque común: sesión, conexión a la base de datos y funciones de apoyo.
 * Todas las páginas incluyen este archivo en su primera línea.
 */
require_once __DIR__ . '/../config/config.php';

if (session_status() === PHP_SESSION_NONE) {
    session_set_cookie_params(['httponly' => true, 'samesite' => 'Lax']);
    session_name('ESMERALDA_SID');
    session_start();
}

/* ---------- Base de datos ---------- */

function db(): PDO
{
    static $pdo = null;
    if ($pdo === null) {
        $dsn = DB_SOCKET !== ''
            ? 'mysql:unix_socket=' . DB_SOCKET . ';dbname=' . DB_NAME . ';charset=utf8mb4'
            : 'mysql:host=' . DB_HOST . ';port=' . DB_PORT . ';dbname=' . DB_NAME . ';charset=utf8mb4';
        try {
            $pdo = new PDO($dsn, DB_USER, DB_PASS, [
                PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES   => false,
            ]);
        } catch (PDOException $ex) {
            http_response_code(500);
            exit('<h2>No se pudo conectar a la base de datos.</h2><p>Verifique que MySQL esté encendido y '
                . 'los datos de config/config.php (o config/config.local.php).</p>');
        }
    }
    return $pdo;
}

/** Ejecuta una consulta preparada y devuelve el PDOStatement. */
function q(string $sql, array $params = []): PDOStatement
{
    $st = db()->prepare($sql);
    $st->execute($params);
    return $st;
}

/* ---------- Utilidades de salida ---------- */

/** Escapa texto para HTML (evita XSS). */
function e($texto): string
{
    return htmlspecialchars((string) $texto, ENT_QUOTES, 'UTF-8');
}

function redirigir(string $url): void
{
    header('Location: ' . $url);
    exit;
}

function flash(string $tipo, string $mensaje): void
{
    $_SESSION['flash'][] = ['tipo' => $tipo, 'msg' => $mensaje];
}

function mostrar_flash(): string
{
    $html = '';
    foreach ($_SESSION['flash'] ?? [] as $f) {
        $html .= '<div class="alerta alerta-' . e($f['tipo']) . '">' . e($f['msg']) . '</div>';
    }
    unset($_SESSION['flash']);
    return $html;
}

function fecha_ve(?string $fecha): string
{
    if (!$fecha) return '—';
    $t = strtotime($fecha);
    return $t ? date('d/m/Y', $t) : '—';
}

/** Edad cumplida a la fecha de hoy. */
function edad(string $fecha_nac): int
{
    return (new DateTime($fecha_nac))->diff(new DateTime('today'))->y;
}

/** Edad deportiva: año actual - año de nacimiento (criterio del fútbol menor). */
function edad_deportiva(string $fecha_nac): int
{
    return (int) date('Y') - (int) substr($fecha_nac, 0, 4);
}

/** Devuelve el id de la categoría que corresponde a la fecha de nacimiento, o null. */
function categoria_sugerida(string $fecha_nac): ?int
{
    $ed = edad_deportiva($fecha_nac);
    $id = q('SELECT id FROM categorias WHERE ? BETWEEN edad_min AND edad_max ORDER BY edad_min LIMIT 1', [$ed])
        ->fetchColumn();
    return $id ? (int) $id : null;
}

/** Valor de $_POST recortado; null si viene vacío. */
function post(string $clave): ?string
{
    $v = trim((string) ($_POST[$clave] ?? ''));
    return $v === '' ? null : $v;
}

/** Deja la cédula sólo con V/E, dígitos y guion, en mayúsculas. */
function limpiar_cedula(?string $ced): ?string
{
    if ($ced === null) return null;
    $ced = strtoupper(preg_replace('/[^0-9VEve\-]/', '', $ced));
    return $ced === '' ? null : $ced;
}

/* ---------- Seguridad: CSRF ---------- */

function csrf_token(): string
{
    if (empty($_SESSION['csrf'])) {
        $_SESSION['csrf'] = bin2hex(random_bytes(32));
    }
    return $_SESSION['csrf'];
}

function csrf_campo(): string
{
    return '<input type="hidden" name="csrf" value="' . csrf_token() . '">';
}

function csrf_verificar(): void
{
    if (!hash_equals($_SESSION['csrf'] ?? '', (string) ($_POST['csrf'] ?? ''))) {
        http_response_code(400);
        exit('Solicitud no válida (token de seguridad). Recargue la página e intente de nuevo.');
    }
}

/* ---------- Autenticación y roles ---------- */

function usuario_actual(): ?array
{
    return $_SESSION['usuario'] ?? null;
}

function requiere_login(): array
{
    $u = usuario_actual();
    if (!$u) {
        redirigir('login.php');
    }
    return $u;
}

/** Jerarquía: administrador > secretaria > entrenador. */
function tiene_rol(string $minimo): bool
{
    $nivel = ['entrenador' => 1, 'secretaria' => 2, 'administrador' => 3];
    $u = usuario_actual();
    return $u && ($nivel[$u['rol']] ?? 0) >= ($nivel[$minimo] ?? 99);
}

function requiere_rol(string $minimo): void
{
    requiere_login();
    if (!tiene_rol($minimo)) {
        flash('error', 'No tiene permisos para realizar esa acción.');
        redirigir('index.php');
    }
}

function puede_editar(): bool
{
    return tiene_rol('secretaria');
}

/* ---------- Bitácora ---------- */

function bitacora(string $accion, string $detalle = ''): void
{
    $u = usuario_actual();
    q('INSERT INTO bitacora (usuario_id, accion, detalle) VALUES (?, ?, ?)',
      [$u['id'] ?? null, $accion, mb_substr($detalle, 0, 255)]);
}

/* ---------- Fotos ---------- */

/**
 * Procesa la foto subida en $_FILES[$campo].
 * Devuelve el nombre del archivo guardado, null si no se subió nada, o lanza una excepción con el error.
 */
function subir_foto(string $campo): ?string
{
    if (empty($_FILES[$campo]) || $_FILES[$campo]['error'] === UPLOAD_ERR_NO_FILE) {
        return null;
    }
    $f = $_FILES[$campo];
    if ($f['error'] !== UPLOAD_ERR_OK) {
        throw new RuntimeException('No se pudo subir la foto (código ' . $f['error'] . ').');
    }
    if ($f['size'] > FOTO_MAX_BYTES) {
        throw new RuntimeException('La foto supera el tamaño máximo de 2 MB.');
    }
    $tipos = ['image/jpeg' => 'jpg', 'image/png' => 'png', 'image/webp' => 'webp'];
    $mime = (new finfo(FILEINFO_MIME_TYPE))->file($f['tmp_name']);
    if (!isset($tipos[$mime])) {
        throw new RuntimeException('La foto debe ser JPG, PNG o WEBP.');
    }
    if (!is_dir(FOTO_DIR)) {
        mkdir(FOTO_DIR, 0775, true);
    }
    $nombre = 'jug_' . date('Ymd_His') . '_' . bin2hex(random_bytes(4)) . '.' . $tipos[$mime];
    if (!move_uploaded_file($f['tmp_name'], FOTO_DIR . $nombre)) {
        throw new RuntimeException('No se pudo guardar la foto en el servidor.');
    }
    return $nombre;
}

function foto_url(?string $foto): ?string
{
    return ($foto && is_file(FOTO_DIR . $foto)) ? FOTO_URL . rawurlencode($foto) : null;
}

/** Iniciales para el avatar cuando no hay foto. */
function iniciales(string $nombres, string $apellidos): string
{
    return mb_strtoupper(mb_substr($nombres, 0, 1) . mb_substr($apellidos, 0, 1));
}
