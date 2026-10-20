<?php
require_once __DIR__ . '/includes/init.php';
requiere_login();
$menu = 'jugadores';
$id = (int) ($_GET['id'] ?? 0);

// Acciones: cambiar estado (secretaria+) o eliminar (sólo administrador)
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    csrf_verificar();
    if (isset($_POST['estado'])) {
        requiere_rol('secretaria');
        if (in_array($_POST['estado'], ['activo', 'inactivo', 'lesionado', 'retirado'], true)) {
            q('UPDATE jugadores SET estado = ? WHERE id = ?', [$_POST['estado'], $id]);
            bitacora('Cambio de estado', "Jugador #$id → {$_POST['estado']}");
            flash('ok', 'Estado actualizado a "' . $_POST['estado'] . '".');
        }
        redirigir('jugador_ver.php?id=' . $id);
    }
    if (isset($_POST['eliminar'])) {
        requiere_rol('administrador');
        $j = q('SELECT nombres, apellidos, foto FROM jugadores WHERE id = ?', [$id])->fetch();
        if ($j) {
            q('DELETE FROM jugadores WHERE id = ?', [$id]);
            if ($j['foto'] && is_file(FOTO_DIR . $j['foto'])) @unlink(FOTO_DIR . $j['foto']);
            bitacora('Eliminar jugador', "#$id {$j['nombres']} {$j['apellidos']}");
            flash('ok', 'Jugador eliminado definitivamente.');
        }
        redirigir('jugadores.php');
    }
}

$j = q('SELECT j.*, c.nombre categoria, c.horario, c.entrenador, u.nombre registrado_por
        FROM jugadores j
        LEFT JOIN categorias c ON c.id = j.categoria_id
        LEFT JOIN usuarios u ON u.id = j.creado_por
        WHERE j.id = ?', [$id])->fetch();
if (!$j) {
    flash('error', 'El jugador no existe.');
    redirigir('jugadores.php');
}
$r = $j['representante_id'] ? q('SELECT * FROM representantes WHERE id = ?', [$j['representante_id']])->fetch() : null;
$hermanos = $r ? q('SELECT id, nombres, apellidos FROM jugadores WHERE representante_id = ? AND id <> ?', [$r['id'], $id])->fetchAll() : [];

$titulo = 'Ficha del jugador';
$foto = foto_url($j['foto']);
require __DIR__ . '/includes/header.php';
?>
<div class="botones no-imprimir">
  <a class="btn btn-sec" href="jugadores.php">← Volver</a>
  <?php if (puede_editar()): ?><a class="btn btn-primario" href="jugador_form.php?id=<?= $id ?>">Editar</a><?php endif; ?>
  <button class="btn" onclick="window.print()">Imprimir ficha</button>
  <a class="btn" href="constancia.php?id=<?= $id ?>" target="_blank">Constancia de inscripción</a>
</div>

<article class="ficha">
  <div class="solo-imprimir encabezado-reporte">
    <strong><?= e(APP_NOMBRE) ?></strong><br><?= e(APP_UBICACION) ?><br>FICHA DEL JUGADOR
  </div>

  <header class="ficha-cab">
    <?php if ($foto): ?><img src="<?= e($foto) ?>" class="foto-grande" alt="Foto"><?php else: ?><div class="foto-grande avatar-grande"><?= e(iniciales($j['nombres'], $j['apellidos'])) ?></div><?php endif; ?>
    <div>
      <h2><?= e($j['nombres'] . ' ' . $j['apellidos']) ?></h2>
      <p>
        <span class="etiqueta etiqueta-<?= e($j['estado']) ?>"><?= e(ucfirst($j['estado'])) ?></span>
        <?= e($j['categoria'] ?? 'Sin categoría') ?> · <?= e($j['posicion']) ?>
        <?= $j['numero_camiseta'] !== null ? ' · Camiseta #' . (int) $j['numero_camiseta'] : '' ?>
      </p>
      <p class="nota">Código de registro: EFE-<?= str_pad((string) $j['id'], 5, '0', STR_PAD_LEFT) ?></p>
    </div>
  </header>

  <div class="rejilla-2">
    <section class="panel">
      <h3>Datos personales</h3>
      <dl>
        <dt>Cédula</dt><dd><?= e($j['cedula'] ?? '—') ?></dd>
        <dt>Fecha de nacimiento</dt><dd><?= fecha_ve($j['fecha_nacimiento']) ?> (<?= edad($j['fecha_nacimiento']) ?> años)</dd>
        <dt>Sexo</dt><dd><?= $j['sexo'] === 'M' ? 'Masculino' : 'Femenino' ?></dd>
        <dt>Lugar de nacimiento</dt><dd><?= e($j['lugar_nacimiento'] ?? '—') ?></dd>
        <dt>Dirección</dt><dd><?= e($j['direccion'] ?? '—') ?></dd>
        <dt>Teléfono</dt><dd><?= e($j['telefono'] ?? '—') ?></dd>
        <dt>Institución educativa</dt><dd><?= e($j['institucion_educativa'] ?? '—') ?> <?= $j['grado'] ? '(' . e($j['grado']) . ')' : '' ?></dd>
      </dl>
    </section>
    <section class="panel">
      <h3>Datos deportivos</h3>
      <dl>
        <dt>Categoría</dt><dd><?= e($j['categoria'] ?? '—') ?></dd>
        <dt>Horario</dt><dd><?= e($j['horario'] ?? '—') ?></dd>
        <dt>Entrenador</dt><dd><?= e($j['entrenador'] ?? '—') ?></dd>
        <dt>Pie dominante</dt><dd><?= e($j['pie_dominante']) ?></dd>
        <dt>Talla de camisa</dt><dd><?= e($j['talla_camisa'] ?? '—') ?></dd>
        <dt>Fecha de inscripción</dt><dd><?= fecha_ve($j['fecha_inscripcion']) ?></dd>
        <dt>Registrado por</dt><dd><?= e($j['registrado_por'] ?? '—') ?></dd>
      </dl>
    </section>
    <section class="panel panel-medico">
      <h3>Datos médicos</h3>
      <dl>
        <dt>Tipo de sangre</dt><dd><strong><?= e($j['tipo_sangre']) ?></strong></dd>
        <dt>Alergias</dt><dd><?= e($j['alergias'] ?? 'Ninguna registrada') ?></dd>
        <dt>Condición médica</dt><dd><?= e($j['condicion_medica'] ?? 'Ninguna registrada') ?></dd>
        <dt>Peso / estatura</dt><dd><?= $j['peso'] ? e($j['peso']) . ' kg' : '—' ?> / <?= $j['estatura'] ? e($j['estatura']) . ' m' : '—' ?></dd>
      </dl>
    </section>
    <section class="panel">
      <h3>Representante</h3>
      <?php if ($r): ?>
      <dl>
        <dt>Nombre</dt><dd><a href="representante_form.php?id=<?= $r['id'] ?>"><?= e($r['nombres'] . ' ' . $r['apellidos']) ?></a> (<?= e($r['parentesco']) ?>)</dd>
        <dt>Cédula</dt><dd><?= e($r['cedula']) ?></dd>
        <dt>Teléfonos</dt><dd><?= e($r['telefono']) ?><?= $r['telefono_alt'] ? ' / ' . e($r['telefono_alt']) : '' ?></dd>
        <dt>Correo</dt><dd><?= e($r['correo'] ?? '—') ?></dd>
        <dt>Dirección</dt><dd><?= e($r['direccion'] ?? '—') ?></dd>
        <?php if ($hermanos): ?>
          <dt>Otros representados</dt>
          <dd><?php foreach ($hermanos as $h): ?><a href="jugador_ver.php?id=<?= $h['id'] ?>"><?= e($h['nombres'] . ' ' . $h['apellidos']) ?></a><br><?php endforeach; ?></dd>
        <?php endif; ?>
      </dl>
      <?php else: ?><p class="vacio">Sin representante asignado.</p><?php endif; ?>
    </section>
  </div>

  <?php if ($j['observaciones']): ?>
    <section class="panel"><h3>Observaciones</h3><p><?= nl2br(e($j['observaciones'])) ?></p></section>
  <?php endif; ?>
</article>

<?php if (puede_editar()): ?>
<section class="panel no-imprimir">
  <h3>Acciones</h3>
  <form method="post" class="en-linea">
    <?= csrf_campo() ?>
    <label>Cambiar estado:
      <select name="estado">
        <?php foreach (['activo', 'inactivo', 'lesionado', 'retirado'] as $es): ?>
          <option value="<?= $es ?>" <?= $j['estado'] === $es ? 'selected' : '' ?>><?= ucfirst($es) ?></option>
        <?php endforeach; ?>
      </select>
    </label>
    <button class="btn">Aplicar</button>
  </form>
</section>
<?php endif; ?>
<?php require __DIR__ . '/includes/footer.php'; ?>
