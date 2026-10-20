<?php
require_once __DIR__ . '/includes/init.php';
requiere_rol('administrador');
$titulo = 'Usuarios del sistema';
$menu = 'usuarios';
$ROLES = ['administrador' => 'Administrador', 'secretaria' => 'Secretaria', 'entrenador' => 'Entrenador'];
$errores = [];
$editar = (int) ($_GET['editar'] ?? 0);
$u = ['nombre' => '', 'usuario' => '', 'rol' => 'secretaria', 'activo' => 1];
if ($editar) {
    $u = q('SELECT * FROM usuarios WHERE id = ?', [$editar])->fetch() ?: $u;
}
$yo = usuario_actual();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    csrf_verificar();
    $id = (int) ($_POST['id'] ?? 0);
    $u['nombre']  = post('nombre');
    $u['usuario'] = strtolower((string) post('usuario'));
    $u['rol']     = $_POST['rol'] ?? '';
    $u['activo']  = isset($_POST['activo']) ? 1 : 0;
    $clave        = (string) ($_POST['clave'] ?? '');

    if (!$u['nombre']) {
        $errores[] = 'El nombre es obligatorio.';
    } elseif (!preg_match('/^[\p{L}\s\'.-]+$/u', $u['nombre'])) {
        $errores[] = 'Solo acepta textos para el campo nombre.';
    }
    if (!preg_match('/^[a-z0-9._]{3,50}$/', $u['usuario'])) $errores[] = 'El usuario debe tener de 3 a 50 caracteres (letras, números, punto o guion bajo).';
    if (!isset($ROLES[$u['rol']])) $errores[] = 'Rol no válido.';
    if (!$id && strlen($clave) < 8) $errores[] = 'La contraseña debe tener al menos 8 caracteres.';
    if ($id && $clave !== '' && strlen($clave) < 8) $errores[] = 'La nueva contraseña debe tener al menos 8 caracteres.';
    if (q('SELECT id FROM usuarios WHERE usuario = ? AND id <> ?', [$u['usuario'], $id])->fetch()) $errores[] = 'Ese nombre de usuario ya existe.';
    if ($id === $yo['id'] && ($u['rol'] !== 'administrador' || !$u['activo'])) $errores[] = 'No puede quitarse a sí mismo el rol de administrador ni desactivarse.';

    if (!$errores) {
        if ($id) {
            q('UPDATE usuarios SET nombre=?, usuario=?, rol=?, activo=? WHERE id=?', [$u['nombre'], $u['usuario'], $u['rol'], $u['activo'], $id]);
            if ($clave !== '') q('UPDATE usuarios SET clave=? WHERE id=?', [password_hash($clave, PASSWORD_DEFAULT), $id]);
            bitacora('Editar usuario', $u['usuario']);
        } else {
            q('INSERT INTO usuarios (nombre, usuario, clave, rol, activo) VALUES (?,?,?,?,?)',
              [$u['nombre'], $u['usuario'], password_hash($clave, PASSWORD_DEFAULT), $u['rol'], $u['activo']]);
            bitacora('Crear usuario', $u['usuario'] . ' (' . $u['rol'] . ')');
        }
        flash('ok', 'Usuario guardado.');
        redirigir('usuarios.php');
    }
    $editar = $id;
}

$usuarios = q('SELECT u.*, (SELECT MAX(fecha) FROM bitacora b WHERE b.usuario_id = u.id) ultimo FROM usuarios u ORDER BY u.nombre')->fetchAll();
require __DIR__ . '/includes/header.php';
?>
<?php if ($errores): ?><div class="alerta alerta-error"><ul><?php foreach ($errores as $er): ?><li><?= e($er) ?></li><?php endforeach; ?></ul></div><?php endif; ?>
<form method="post" class="formulario" id="form" autocomplete="off">
  <?= csrf_campo() ?>
  <input type="hidden" name="id" value="<?= $editar ?>">
  <fieldset>
    <legend><?= $editar ? 'Editar usuario' : 'Nuevo usuario' ?></legend>
    <div class="campos">
      <label>Nombre completo * <input name="nombre" id="nombre" required maxlength="100" pattern="[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s'-]+" title="Solo acepta textos para el campo nombre" value="<?= e($u['nombre']) ?>"></label>
      <label>Usuario * <input name="usuario" required maxlength="50" value="<?= e($u['usuario']) ?>"></label>
      <label>Rol *
        <select name="rol"><?php foreach ($ROLES as $k => $t): ?><option value="<?= $k ?>" <?= $u['rol'] === $k ? 'selected' : '' ?>><?= $t ?></option><?php endforeach; ?></select>
      </label>
      <label><?= $editar ? 'Nueva contraseña (dejar en blanco para no cambiar)' : 'Contraseña *' ?>
        <input type="password" name="clave" minlength="8" <?= $editar ? '' : 'required' ?> autocomplete="new-password"></label>
      <label class="check"><input type="checkbox" name="activo" <?= $u['activo'] ? 'checked' : '' ?>> Usuario activo</label>
    </div>
    <p class="ayuda"><strong>Administrador:</strong> acceso total. <strong>Secretaria:</strong> registra y edita jugadores y representantes. <strong>Entrenador:</strong> sólo consulta y reportes.</p>
  </fieldset>
  <div class="botones botones-der" style="justify-content: flex-end;">
    <?php if ($editar): ?><a class="btn btn-sec" href="usuarios.php">Cancelar</a><?php endif; ?>
    <button class="btn btn-primario">Guardar</button>
  </div>
</form>

<hr class="divisor" style="border:0; border-top:1px solid var(--borde); margin:24px 0;">

<div class="tabla-envoltura">
<table class="tabla">
  <thead><tr><th>Nombre</th><th>Usuario</th><th>Rol</th><th>Estado</th><th>Última actividad</th><th></th></tr></thead>
  <tbody>
  <?php foreach ($usuarios as $x): ?>
    <tr>
      <td><?= e($x['nombre']) ?></td><td><?= e($x['usuario']) ?></td><td><?= e($ROLES[$x['rol']]) ?></td>
      <td><span class="etiqueta etiqueta-<?= $x['activo'] ? 'activo' : 'retirado' ?>"><?= $x['activo'] ? 'Activo' : 'Bloqueado' ?></span></td>
      <td><?= $x['ultimo'] ? date('d/m/Y h:i a', strtotime($x['ultimo'])) : '—' ?></td>
      <td class="acciones"><a href="usuarios.php?editar=<?= $x['id'] ?>#form">Editar</a></td>
    </tr>
  <?php endforeach; ?>
  </tbody>
</table>
</div>

<script>
document.addEventListener('DOMContentLoaded', function () {
  var form = document.getElementById('form');
  var inputNombre = document.getElementById('nombre');
  if (!form || !inputNombre) return;

  var soloTextoRegex = /^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s'-]+$/;

  function validarNombre(mostrarAlerta) {
    var val = inputNombre.value.trim();
    if (val !== '' && !soloTextoRegex.test(val)) {
      inputNombre.setCustomValidity('Solo acepta textos para el campo nombre');
      if (mostrarAlerta) {
        alert('Solo acepta textos para el campo nombre');
        inputNombre.focus();
      }
      return false;
    } else {
      inputNombre.setCustomValidity('');
      return true;
    }
  }

  inputNombre.addEventListener('input', function () {
    validarNombre(false);
  });

  inputNombre.addEventListener('change', function () {
    validarNombre(true);
  });

  form.addEventListener('submit', function (ev) {
    if (!validarNombre(true)) {
      ev.preventDefault();
      if (typeof inputNombre.reportValidity === 'function') {
        inputNombre.reportValidity();
      }
    }
  });
});
</script>
<?php require __DIR__ . '/includes/footer.php'; ?>
