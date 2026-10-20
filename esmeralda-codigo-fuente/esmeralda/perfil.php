<?php
require_once __DIR__ . '/includes/init.php';
$yo = requiere_login();
$titulo = 'Cambiar contraseña';
$errores = [];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    csrf_verificar();
    $actual = (string) ($_POST['actual'] ?? '');
    $nueva  = (string) ($_POST['nueva'] ?? '');
    $repite = (string) ($_POST['repite'] ?? '');
    $hash = q('SELECT clave FROM usuarios WHERE id = ?', [$yo['id']])->fetchColumn();

    if (!password_verify($actual, (string) $hash)) $errores[] = 'La contraseña actual no es correcta.';
    if (strlen($nueva) < 8) $errores[] = 'La nueva contraseña debe tener al menos 8 caracteres.';
    if ($nueva !== $repite) $errores[] = 'Las contraseñas nuevas no coinciden.';

    if (!$errores) {
        q('UPDATE usuarios SET clave = ? WHERE id = ?', [password_hash($nueva, PASSWORD_DEFAULT), $yo['id']]);
        bitacora('Cambio de clave', $yo['usuario']);
        flash('ok', 'Contraseña actualizada.');
        redirigir('index.php');
    }
}
require __DIR__ . '/includes/header.php';
?>
<?php if ($errores): ?><div class="alerta alerta-error"><ul><?php foreach ($errores as $er): ?><li><?= e($er) ?></li><?php endforeach; ?></ul></div><?php endif; ?>
<form method="post" class="formulario angosto">
  <?= csrf_campo() ?>
  <fieldset>
    <legend><?= e($yo['nombre']) ?> (<?= e($yo['usuario']) ?>)</legend>
    <label>Contraseña actual <input type="password" name="actual" required autocomplete="current-password"></label>
    <label>Nueva contraseña (mín. 8) <input type="password" name="nueva" required minlength="8" autocomplete="new-password"></label>
    <label>Repita la nueva contraseña <input type="password" name="repite" required minlength="8" autocomplete="new-password"></label>
  </fieldset>
  <div class="botones"><button class="btn btn-primario">Guardar</button></div>
</form>
<?php require __DIR__ . '/includes/footer.php'; ?>
