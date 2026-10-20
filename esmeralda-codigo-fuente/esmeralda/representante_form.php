<?php
require_once __DIR__ . '/includes/init.php';
requiere_login();
$menu = 'representantes';
$id = (int) ($_GET['id'] ?? 0);
$PAREN = ['Madre', 'Padre', 'Abuelo(a)', 'Tío(a)', 'Hermano(a)', 'Tutor legal', 'Otro'];

$r = ['parentesco' => 'Madre'];
if ($id) {
    $r = q('SELECT * FROM representantes WHERE id = ?', [$id])->fetch();
    if (!$r) {
        flash('error', 'El representante no existe.');
        redirigir('representantes.php');
    }
}
$titulo = $id ? 'Representante' : 'Nuevo representante';
$errores = [];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    requiere_rol('secretaria');
    csrf_verificar();

    if (isset($_POST['eliminar'])) {
        requiere_rol('administrador');
        $n = (int) q('SELECT COUNT(*) FROM jugadores WHERE representante_id = ?', [$id])->fetchColumn();
        if ($n > 0) {
            flash('error', "No se puede eliminar: tiene $n jugador(es) a su cargo.");
            redirigir('representante_form.php?id=' . $id);
        }
        q('DELETE FROM representantes WHERE id = ?', [$id]);
        bitacora('Eliminar representante', "#$id {$r['cedula']}");
        flash('ok', 'Representante eliminado.');
        redirigir('representantes.php');
    }

    $campos = ['cedula', 'nombres', 'apellidos', 'parentesco', 'telefono', 'telefono_alt', 'correo', 'direccion', 'ocupacion'];
    foreach ($campos as $c) $r[$c] = post($c);
    $r['cedula'] = limpiar_cedula($r['cedula']);

    if (!$r['cedula'])    $errores[] = 'La cédula es obligatoria.';
    if (!$r['nombres'])   $errores[] = 'Los nombres son obligatorios.';
    if (!$r['apellidos']) $errores[] = 'Los apellidos son obligatorios.';
    if (!$r['telefono'])  $errores[] = 'El teléfono es obligatorio.';
    if ($r['correo'] && !filter_var($r['correo'], FILTER_VALIDATE_EMAIL)) $errores[] = 'El correo no es válido.';
    if (!in_array($r['parentesco'], $PAREN, true)) $r['parentesco'] = 'Otro';
    if ($r['cedula'] && q('SELECT id FROM representantes WHERE cedula = ? AND id <> ?', [$r['cedula'], $id])->fetch()) {
        $errores[] = 'Ya existe otro representante con esa cédula.';
    }

    if (!$errores) {
        $vals = array_map(fn($c) => $r[$c], $campos);
        if ($id) {
            $set = implode(', ', array_map(fn($c) => "$c = ?", $campos));
            q("UPDATE representantes SET $set WHERE id = ?", [...$vals, $id]);
            bitacora('Editar representante', "#$id {$r['cedula']}");
        } else {
            q('INSERT INTO representantes (' . implode(',', $campos) . ') VALUES (' . implode(',', array_fill(0, count($campos), '?')) . ')', $vals);
            $id = (int) db()->lastInsertId();
            bitacora('Registrar representante', "#$id {$r['cedula']}");
        }
        flash('ok', 'Representante guardado.');
        redirigir('representante_form.php?id=' . $id);
    }
}

$jugadores = $id ? q('SELECT j.id, j.nombres, j.apellidos, j.estado, c.nombre categoria FROM jugadores j
                      LEFT JOIN categorias c ON c.id = j.categoria_id WHERE j.representante_id = ?', [$id])->fetchAll() : [];
$soloLectura = !puede_editar();
require __DIR__ . '/includes/header.php';
?>
<?php if ($errores): ?>
  <div class="alerta alerta-error"><ul><?php foreach ($errores as $er): ?><li><?= e($er) ?></li><?php endforeach; ?></ul></div>
<?php endif; ?>

<form method="post" class="formulario">
  <?= csrf_campo() ?>
  <fieldset <?= $soloLectura ? 'disabled' : '' ?>>
    <legend>Datos del representante</legend>
    <div class="campos">
      <label>Cédula * <input name="cedula" required maxlength="15" value="<?= e($r['cedula'] ?? '') ?>"></label>
      <label>Nombres * <input name="nombres" required maxlength="80" value="<?= e($r['nombres'] ?? '') ?>"></label>
      <label>Apellidos * <input name="apellidos" required maxlength="80" value="<?= e($r['apellidos'] ?? '') ?>"></label>
      <label>Parentesco
        <select name="parentesco"><?php foreach ($PAREN as $p): ?><option <?= ($r['parentesco'] ?? '') === $p ? 'selected' : '' ?>><?= e($p) ?></option><?php endforeach; ?></select>
      </label>
      <label>Teléfono * <input name="telefono" required maxlength="20" value="<?= e($r['telefono'] ?? '') ?>"></label>
      <label>Teléfono alterno <input name="telefono_alt" maxlength="20" value="<?= e($r['telefono_alt'] ?? '') ?>"></label>
      <label>Correo <input type="email" name="correo" maxlength="120" value="<?= e($r['correo'] ?? '') ?>"></label>
      <label>Ocupación <input name="ocupacion" maxlength="80" value="<?= e($r['ocupacion'] ?? '') ?>"></label>
      <label class="ancho">Dirección <input name="direccion" maxlength="255" value="<?= e($r['direccion'] ?? '') ?>"></label>
    </div>
  </fieldset>
  <div class="botones">
    <?php if (!$soloLectura): ?><button class="btn btn-primario">Guardar</button><?php endif; ?>
    <a class="btn btn-sec" href="representantes.php">Volver</a>
  </div>
</form>

<?php if ($id): ?>
<section class="panel">
  <h3>Jugadores a su cargo</h3>
  <?php if (!$jugadores): ?><p class="vacio">Ninguno.</p><?php endif; ?>
  <ul>
    <?php foreach ($jugadores as $j): ?>
      <li><a href="jugador_ver.php?id=<?= $j['id'] ?>"><?= e($j['nombres'] . ' ' . $j['apellidos']) ?></a> — <?= e($j['categoria'] ?? 'Sin categoría') ?> (<?= e($j['estado']) ?>)</li>
    <?php endforeach; ?>
  </ul>
  <?php if (tiene_rol('administrador') && !$jugadores): ?>
    <form method="post" data-confirmar="¿Eliminar este representante?">
      <?= csrf_campo() ?><input type="hidden" name="eliminar" value="1">
      <button class="btn btn-peligro">Eliminar representante</button>
    </form>
  <?php endif; ?>
</section>
<?php endif; ?>
<?php require __DIR__ . '/includes/footer.php'; ?>
