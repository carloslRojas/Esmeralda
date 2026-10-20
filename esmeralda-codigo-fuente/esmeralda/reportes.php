<?php
require_once __DIR__ . '/includes/init.php';
requiere_login();
$titulo = 'Reportes';
$menu = 'reportes';

$tipo      = $_GET['tipo'] ?? '';
$categoria = $_GET['categoria'] ?? '';
$estado    = $_GET['estado'] ?? 'activo';
$categorias = q('SELECT id, nombre, horario, entrenador FROM categorias ORDER BY edad_min')->fetchAll();

$TIPOS = [
    'listado'    => 'Listado de jugadores por categoría',
    'asistencia' => 'Planilla de asistencia',
    'medico'     => 'Datos médicos y contactos de emergencia',
    'estadistica'=> 'Estadística general',
];

$filas = [];
$catSel = null;
if (isset($TIPOS[$tipo]) && $tipo !== 'estadistica') {
    $where = [];
    $params = [];
    if ($categoria !== '') {
        $where[] = 'j.categoria_id = ?';
        $params[] = (int) $categoria;
        foreach ($categorias as $c) if ((string) $c['id'] === (string) $categoria) $catSel = $c;
    }
    if (in_array($estado, ['activo', 'inactivo', 'lesionado', 'retirado'], true)) {
        $where[] = 'j.estado = ?';
        $params[] = $estado;
    }
    $filas = q('SELECT j.*, c.nombre categoria, CONCAT_WS(\' \', r.nombres, r.apellidos) representante, r.telefono tel_rep, r.cedula ced_rep
                FROM jugadores j
                LEFT JOIN categorias c ON c.id = j.categoria_id
                LEFT JOIN representantes r ON r.id = j.representante_id ' .
                ($where ? 'WHERE ' . implode(' AND ', $where) : '') .
                ' ORDER BY c.edad_min, j.apellidos, j.nombres', $params)->fetchAll();
    bitacora('Reporte', $TIPOS[$tipo] . ($catSel ? ' - ' . $catSel['nombre'] : ''));
}

if ($tipo === 'estadistica') {
    $porCat = q("SELECT COALESCE(c.nombre,'Sin categoría') nombre,
                        SUM(j.sexo='M') m, SUM(j.sexo='F') f, COUNT(*) total
                 FROM jugadores j LEFT JOIN categorias c ON c.id = j.categoria_id
                 WHERE j.estado = 'activo' GROUP BY c.id, c.nombre, c.edad_min ORDER BY c.edad_min IS NULL, c.edad_min")->fetchAll();
    $porEstado = q('SELECT estado, COUNT(*) total FROM jugadores GROUP BY estado')->fetchAll(PDO::FETCH_KEY_PAIR);
    $porPos = q("SELECT posicion, COUNT(*) total FROM jugadores WHERE estado='activo' GROUP BY posicion ORDER BY total DESC")->fetchAll(PDO::FETCH_KEY_PAIR);
    $porAnio = q("SELECT YEAR(fecha_inscripcion) anio, COUNT(*) total FROM jugadores GROUP BY anio ORDER BY anio DESC")->fetchAll(PDO::FETCH_KEY_PAIR);
}

require __DIR__ . '/includes/header.php';
?>
<form class="filtros no-imprimir" method="get">
  <select name="tipo" required>
    <option value="">— Tipo de reporte —</option>
    <?php foreach ($TIPOS as $k => $t): ?><option value="<?= $k ?>" <?= $tipo === $k ? 'selected' : '' ?>><?= e($t) ?></option><?php endforeach; ?>
  </select>
  <select name="categoria">
    <option value="">Todas las categorías</option>
    <?php foreach ($categorias as $c): ?><option value="<?= $c['id'] ?>" <?= (string) $categoria === (string) $c['id'] ? 'selected' : '' ?>><?= e($c['nombre']) ?></option><?php endforeach; ?>
  </select>
  <select name="estado">
    <?php foreach (['activo' => 'Activos', 'inactivo' => 'Inactivos', 'lesionado' => 'Lesionados', 'retirado' => 'Retirados', 'todos' => 'Todos'] as $v => $t): ?>
      <option value="<?= $v ?>" <?= $estado === $v ? 'selected' : '' ?>><?= $t ?></option>
    <?php endforeach; ?>
  </select>
  <button class="btn btn-primario">Generar</button>
  <?php if ($tipo): ?><button type="button" class="btn" onclick="window.print()">Imprimir</button><?php endif; ?>
</form>

<?php if (!$tipo): ?>
  <div class="panel">
    <p>Seleccione el tipo de reporte, la categoría y el estado, y pulse <strong>Generar</strong>. Luego use <strong>Imprimir</strong> (o «Guardar como PDF» en el cuadro de impresión).</p>
    <ul><?php foreach ($TIPOS as $t): ?><li><?= e($t) ?></li><?php endforeach; ?><li>Constancia de inscripción: desde la ficha de cada jugador.</li></ul>
  </div>
<?php elseif (isset($TIPOS[$tipo])): ?>
  <div class="encabezado-reporte">
    <strong><?= e(APP_NOMBRE) ?></strong> — <?= e(APP_UBICACION) ?><br>
    <span class="titulo-rep"><?= e(mb_strtoupper($TIPOS[$tipo])) ?></span><br>
    <?php if ($catSel): ?>Categoría: <strong><?= e($catSel['nombre']) ?></strong><?= $catSel['horario'] ? ' · ' . e($catSel['horario']) : '' ?><?= $catSel['entrenador'] ? ' · Entrenador: ' . e($catSel['entrenador']) : '' ?><br><?php endif; ?>
    <small>Emitido el <?= date('d/m/Y h:i a') ?> por <?= e(usuario_actual()['nombre']) ?></small>
  </div>

  <?php if ($tipo === 'listado'): ?>
    <table class="tabla tabla-reporte">
      <thead><tr><th>N°</th><th>Apellidos y nombres</th><th>Cédula</th><th>F. nac.</th><th>Edad</th><th>Sexo</th><th>Categoría</th><th>Posición</th><th>Representante</th><th>Teléfono</th></tr></thead>
      <tbody>
      <?php foreach ($filas as $i => $f): ?>
        <tr><td><?= $i + 1 ?></td><td><?= e($f['apellidos'] . ', ' . $f['nombres']) ?></td><td><?= e($f['cedula'] ?? '') ?></td>
            <td><?= fecha_ve($f['fecha_nacimiento']) ?></td><td><?= edad($f['fecha_nacimiento']) ?></td><td><?= e($f['sexo']) ?></td>
            <td><?= e($f['categoria'] ?? '—') ?></td><td><?= e($f['posicion']) ?></td><td><?= e($f['representante'] ?? '') ?></td><td><?= e($f['tel_rep'] ?? '') ?></td></tr>
      <?php endforeach; ?>
      </tbody>
    </table>

  <?php elseif ($tipo === 'asistencia'): ?>
    <p class="nota">Mes: ______________ &nbsp; Semana del ____ al ____</p>
    <table class="tabla tabla-reporte asistencia">
      <thead><tr><th>N°</th><th>Apellidos y nombres</th><th>#</th><?php for ($i = 1; $i <= 12; $i++): ?><th></th><?php endfor; ?></tr></thead>
      <tbody>
      <?php foreach ($filas as $i => $f): ?>
        <tr><td><?= $i + 1 ?></td><td><?= e($f['apellidos'] . ', ' . $f['nombres']) ?></td><td><?= e($f['numero_camiseta'] ?? '') ?></td><?php for ($k = 1; $k <= 12; $k++): ?><td></td><?php endfor; ?></tr>
      <?php endforeach; ?>
      </tbody>
    </table>

  <?php elseif ($tipo === 'medico'): ?>
    <table class="tabla tabla-reporte">
      <thead><tr><th>N°</th><th>Jugador</th><th>Edad</th><th>Sangre</th><th>Alergias</th><th>Condición médica</th><th>Representante</th><th>Teléfono</th></tr></thead>
      <tbody>
      <?php foreach ($filas as $i => $f): ?>
        <tr><td><?= $i + 1 ?></td><td><?= e($f['apellidos'] . ', ' . $f['nombres']) ?></td><td><?= edad($f['fecha_nacimiento']) ?></td>
            <td><strong><?= e($f['tipo_sangre']) ?></strong></td><td><?= e($f['alergias'] ?? '') ?></td><td><?= e($f['condicion_medica'] ?? '') ?></td>
            <td><?= e($f['representante'] ?? '') ?></td><td><?= e($f['tel_rep'] ?? '') ?></td></tr>
      <?php endforeach; ?>
      </tbody>
    </table>

  <?php elseif ($tipo === 'estadistica'): ?>
    <div class="rejilla-2">
      <section class="panel">
        <h3>Jugadores activos por categoría y sexo</h3>
        <table class="tabla tabla-reporte">
          <thead><tr><th>Categoría</th><th>Masc.</th><th>Fem.</th><th>Total</th></tr></thead>
          <tbody>
          <?php $tm = $tf = 0; foreach ($porCat as $p): $tm += $p['m']; $tf += $p['f']; ?>
            <tr><td><?= e($p['nombre']) ?></td><td><?= (int) $p['m'] ?></td><td><?= (int) $p['f'] ?></td><td><strong><?= (int) $p['total'] ?></strong></td></tr>
          <?php endforeach; ?>
          </tbody>
          <tfoot><tr><th>Total</th><th><?= $tm ?></th><th><?= $tf ?></th><th><?= $tm + $tf ?></th></tr></tfoot>
        </table>
      </section>
      <section class="panel">
        <h3>Por estado</h3>
        <table class="tabla tabla-reporte"><tbody>
          <?php foreach (['activo', 'inactivo', 'lesionado', 'retirado'] as $es): ?><tr><td><?= ucfirst($es) ?></td><td><?= (int) ($porEstado[$es] ?? 0) ?></td></tr><?php endforeach; ?>
        </tbody></table>
        <h3>Activos por posición</h3>
        <table class="tabla tabla-reporte"><tbody>
          <?php foreach ($porPos as $pos => $n): ?><tr><td><?= e($pos) ?></td><td><?= (int) $n ?></td></tr><?php endforeach; ?>
        </tbody></table>
        <h3>Inscripciones por año</h3>
        <table class="tabla tabla-reporte"><tbody>
          <?php foreach ($porAnio as $a => $n): ?><tr><td><?= (int) $a ?></td><td><?= (int) $n ?></td></tr><?php endforeach; ?>
        </tbody></table>
      </section>
    </div>
  <?php endif; ?>

  <?php if ($tipo !== 'estadistica'): ?>
    <p class="nota">Total: <?= count($filas) ?> jugador(es).</p>
    <?php if (!$filas): ?><p class="vacio">No hay jugadores con esos criterios.</p><?php endif; ?>
  <?php endif; ?>
  <div class="firmas solo-imprimir"><div><span></span>Firma del responsable</div></div>
<?php endif; ?>
<?php require __DIR__ . '/includes/footer.php'; ?>
