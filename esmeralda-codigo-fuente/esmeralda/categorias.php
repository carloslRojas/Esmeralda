<?php
require_once __DIR__ . '/includes/init.php';
requiere_login();
$titulo = 'Categorías';
$menu = 'categorias';
$errores = [];
$editar = (int) ($_GET['editar'] ?? 0);
$c = ['nombre' => '', 'edad_min' => '', 'edad_max' => '', 'horario' => '', 'entrenador' => '', 'descripcion' => ''];
if ($editar) {
    $c = q('SELECT * FROM categorias WHERE id = ?', [$editar])->fetch() ?: $c;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    requiere_rol('administrador');
    csrf_verificar();
    $id = (int) ($_POST['id'] ?? 0);

    if (isset($_POST['eliminar'])) {
        $n = (int) q('SELECT COUNT(*) FROM jugadores WHERE categoria_id = ?', [$id])->fetchColumn();
        if ($n) {
            flash('error', "No se puede eliminar: la categoría tiene $n jugador(es). Reasígnelos primero.");
        } else {
            q('DELETE FROM categorias WHERE id = ?', [$id]);
            bitacora('Eliminar categoría', "#$id");
            flash('ok', 'Categoría eliminada.');
        }
        redirigir('categorias.php');
    }

    if (isset($_POST['reasignar'])) {
        // Recalcula la categoría de todos los jugadores activos según su edad deportiva
        $n = 0;
        foreach (q("SELECT id, fecha_nacimiento FROM jugadores WHERE estado = 'activo'")->fetchAll() as $j) {
            $n += q('UPDATE jugadores SET categoria_id = ? WHERE id = ?', [categoria_sugerida($j['fecha_nacimiento']), $j['id']])->rowCount();
        }
        bitacora('Reasignar categorías', "$n jugador(es) cambiaron de categoría");
        flash('ok', "Categorías recalculadas. $n jugador(es) cambiaron de categoría.");
        redirigir('categorias.php');
    }

    foreach (array_keys($c) as $k) {
        if ($k !== 'id') $c[$k] = post($k);
    }
    if (!$c['nombre']) $errores[] = 'El nombre es obligatorio.';
    if (!ctype_digit((string) $c['edad_min']) || !ctype_digit((string) $c['edad_max']) || $c['edad_min'] > $c['edad_max']) {
        $errores[] = 'Indique un rango de edad válido (mínima ≤ máxima).';
    }
    if (q('SELECT id FROM categorias WHERE nombre = ? AND id <> ?', [$c['nombre'], $id])->fetch()) {
        $errores[] = 'Ya existe una categoría con ese nombre.';
    }
    if (!$errores) {
        $vals = [$c['nombre'], $c['edad_min'], $c['edad_max'], $c['horario'], $c['entrenador'], $c['descripcion']];
        if ($id) {
            q('UPDATE categorias SET nombre=?, edad_min=?, edad_max=?, horario=?, entrenador=?, descripcion=? WHERE id=?', [...$vals, $id]);
            bitacora('Editar categoría', $c['nombre']);
        } else {
            q('INSERT INTO categorias (nombre, edad_min, edad_max, horario, entrenador, descripcion) VALUES (?,?,?,?,?,?)', $vals);
            bitacora('Crear categoría', $c['nombre']);
        }
        flash('ok', 'Categoría guardada.');
        redirigir('categorias.php');
    }
    $editar = $id;
}

$cats = q("SELECT c.*,
                  (SELECT COUNT(*) FROM jugadores j WHERE j.categoria_id = c.id AND j.estado = 'activo') activos,
                  (SELECT COUNT(*) FROM jugadores j WHERE j.categoria_id = c.id) total
           FROM categorias c ORDER BY c.edad_min")->fetchAll();
$anio = (int) date('Y');
require __DIR__ . '/includes/header.php';
?>
<p class="nota">Edad deportiva = año en curso (<?= $anio ?>) − año de nacimiento. Ejemplo: un niño nacido en <?= $anio - 9 ?> tiene 9 años deportivos este año.</p>
<div class="tabla-envoltura">
<table class="tabla">
  <thead><tr><th>Categoría</th><th>Edades</th><th>Años de nacimiento (<?= $anio ?>)</th><th>Horario</th><th>Entrenador</th><th>Activos</th><th></th></tr></thead>
  <tbody>
  <?php foreach ($cats as $k): ?>
    <tr>
      <td><strong><?= e($k['nombre']) ?></strong><br><small><?= e($k['descripcion'] ?? '') ?></small></td>
      <td><?= $k['edad_min'] ?>–<?= $k['edad_max'] ?></td>
      <td><?= $anio - $k['edad_max'] ?>–<?= $anio - $k['edad_min'] ?></td>
      <td><?= e($k['horario'] ?? '—') ?></td>
      <td><?= e($k['entrenador'] ?? '—') ?></td>
      <td><a href="jugadores.php?categoria=<?= $k['id'] ?>"><?= (int) $k['activos'] ?></a></td>
      <td class="acciones">
        <?php if (tiene_rol('administrador')): ?>
          <a href="categorias.php?editar=<?= $k['id'] ?>#form">Editar</a>
          <?php if (!$k['total']): ?>
          <form method="post" class="en-linea" data-confirmar="¿Eliminar la categoría <?= e($k['nombre']) ?>?">
            <?= csrf_campo() ?><input type="hidden" name="id" value="<?= $k['id'] ?>"><input type="hidden" name="eliminar" value="1">
            <button class="enlace peligro">Eliminar</button>
          </form>
          <?php endif; ?>
        <?php endif; ?>
      </td>
    </tr>
  <?php endforeach; ?>
  </tbody>
</table>
</div>

<?php if (tiene_rol('administrador')): ?>
<?php if ($errores): ?><div class="alerta alerta-error"><ul><?php foreach ($errores as $er): ?><li><?= e($er) ?></li><?php endforeach; ?></ul></div><?php endif; ?>
<form method="post" class="formulario" id="form">
  <?= csrf_campo() ?>
  <input type="hidden" name="id" value="<?= $editar ?>">
  <fieldset>
    <legend><?= $editar ? 'Editar categoría' : 'Nueva categoría' ?></legend>
    <div class="campos">
      <label>Nombre * <input name="nombre" required maxlength="30" placeholder="Sub-12" value="<?= e($c['nombre']) ?>"></label>
      <label>Edad mínima * <input type="number" name="edad_min" min="3" max="20" required value="<?= e($c['edad_min']) ?>"></label>
      <label>Edad máxima * <input type="number" name="edad_max" min="3" max="20" required value="<?= e($c['edad_max']) ?>"></label>
      <label>Horario <input name="horario" maxlength="120" value="<?= e($c['horario']) ?>"></label>
      <label>Entrenador <input name="entrenador" maxlength="100" value="<?= e($c['entrenador']) ?>"></label>
      <label>Descripción <input name="descripcion" maxlength="255" value="<?= e($c['descripcion']) ?>"></label>
    </div>
  </fieldset>
  <div class="botones">
    <button class="btn btn-primario">Guardar</button>
    <?php if ($editar): ?><a class="btn btn-sec" href="categorias.php">Cancelar</a><?php endif; ?>
  </div>
</form>

<section class="panel">
  <h3>Cambio de temporada</h3>
  <p>Al comenzar un nuevo año, los jugadores suben de categoría. Este botón recalcula la categoría de todos los jugadores <strong>activos</strong> según su año de nacimiento.</p>
  <form method="post" data-confirmar="¿Recalcular la categoría de todos los jugadores activos?">
    <?= csrf_campo() ?><input type="hidden" name="reasignar" value="1">
    <button class="btn">Recalcular categorías</button>
  </form>
</section>
<?php endif; ?>
<?php require __DIR__ . '/includes/footer.php'; ?>
