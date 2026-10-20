<?php
require_once __DIR__ . '/includes/init.php';

if (usuario_actual()) {
    redirigir('index.php');
}

$error = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    csrf_verificar();
    $usuario = post('usuario') ?? '';
    $clave   = (string) ($_POST['clave'] ?? '');

    // Freno simple a intentos repetidos (por sesión)
    $_SESSION['intentos'] = $_SESSION['intentos'] ?? 0;
    if ($_SESSION['intentos'] >= 5 && time() - ($_SESSION['ultimo_intento'] ?? 0) < 60) {
        $error = 'Demasiados intentos. Espere un minuto.';
    } else {
        $fila = q('SELECT * FROM usuarios WHERE usuario = ? LIMIT 1', [$usuario])->fetch();
        if ($fila && $fila['activo'] && password_verify($clave, $fila['clave'])) {
            session_regenerate_id(true);
            $_SESSION['usuario'] = [
                'id' => (int) $fila['id'], 'nombre' => $fila['nombre'],
                'usuario' => $fila['usuario'], 'rol' => $fila['rol'],
            ];
            $_SESSION['intentos'] = 0;
            if (password_needs_rehash($fila['clave'], PASSWORD_DEFAULT)) {
                q('UPDATE usuarios SET clave = ? WHERE id = ?', [password_hash($clave, PASSWORD_DEFAULT), $fila['id']]);
            }
            bitacora('Inicio de sesión', 'Usuario ' . $fila['usuario']);
            redirigir('index.php');
        }
        $_SESSION['intentos']++;
        $_SESSION['ultimo_intento'] = time();
        $error = 'Usuario o contraseña incorrectos.';
    }
}
?><!DOCTYPE html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Ingresar · <?= e(APP_SIGLAS) ?></title>
<link rel="stylesheet" href="assets/css/estilos.css">
</head>
<body class="pagina-login">
  <form method="post" class="caja-login" autocomplete="off">
    <svg viewBox="0 0 40 40" width="64" height="64" aria-hidden="true">
      <path d="M20 2 L36 8 V20 C36 30 28 36 20 38 C12 36 4 30 4 20 V8 Z" fill="#0f7a4f" stroke="#e9c46a" stroke-width="2"/>
      <circle cx="20" cy="20" r="8" fill="#fff"/>
      <path d="M20 14 l4 3 -1.5 5 h-5 L16 17 z" fill="#0f7a4f"/>
    </svg>
    <h1><?= e(APP_NOMBRE) ?></h1>
    <p class="sub">Sistema administrativo de registro de jugadores</p>
    <?php if ($error): ?><div class="alerta alerta-error"><?= e($error) ?></div><?php endif; ?>
    <?= csrf_campo() ?>
    <label>Usuario <input name="usuario" required autofocus maxlength="50"></label>
    <label>Contraseña <input type="password" name="clave" required></label>
    <button class="btn btn-primario btn-bloque">Ingresar</button>
    <p class="sub"><?= e(APP_UBICACION) ?></p>
  </form>
</body>
</html>
