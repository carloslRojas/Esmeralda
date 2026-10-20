<?php
require_once __DIR__ . '/includes/init.php';
requiere_rol('administrador');
$titulo = 'Bitácora de actividades';
$menu = 'bitacora';

$desde = $_GET['desde'] ?? date('Y-m-d', strtotime('-30 days'));
$hasta = $_GET['hasta'] ?? date('Y-m-d');
$usr   = (int) ($_GET['usuario'] ?? 0);
if (!DateTime::createFromFormat('Y-m-d', $desde)) $desde = date('Y-m-d', strtotime('-30 days'));
if (!DateTime::createFromFormat('Y-m-d', $hasta)) $hasta = date('Y-m-d');

$params = [$desde . ' 00:00:00', $hasta . ' 23:59:59'];
$sql = 'SELECT b.*, u.nombre, u.usuario FROM bitacora b LEFT JOIN usuarios u ON u.id = b.usuario_id WHERE b.fecha BETWEEN ? AND ?';
if ($usr) {
    $sql .= ' AND b.usuario_id = ?';
    $params[] = $usr;
}
$registros = q($sql . ' ORDER BY b.id DESC LIMIT 500', $params)->fetchAll();
$usuarios = q('SELECT id, nombre FROM usuarios ORDER BY nombre')->fetchAll();
require __DIR__ . '/includes/header.php';
?>
<form class="filtros" method="get">
  <label>Desde <input type="date" name="desde" value="<?= e($desde) ?>"></label>
  <label>Hasta <input type="date" name="hasta" value="<?= e($hasta) ?>"></label>
  <select name="usuario"><option value="">Todos los usuarios</option>
    <?php foreach ($usuarios as $x): ?><option value="<?= $x['id'] ?>" <?= $usr === (int) $x['id'] ? 'selected' : '' ?>><?= e($x['nombre']) ?></option><?php endforeach; ?>
  </select>
  <button class="btn">Filtrar</button>
</form>
<div class="tabla-envoltura">
<table class="tabla">
  <thead><tr><th>Fecha y hora</th><th>Usuario</th><th>Acción</th><th>Detalle</th></tr></thead>
  <tbody>
  <?php if (!$registros): ?><tr><td colspan="4" class="vacio">Sin registros en el período.</td></tr><?php endif; ?>
  <?php foreach ($registros as $b): ?>
    <tr><td><?= date('d/m/Y h:i:s a', strtotime($b['fecha'])) ?></td><td><?= e($b['usuario'] ?? '—') ?></td><td><?= e($b['accion']) ?></td><td><?= e($b['detalle']) ?></td></tr>
  <?php endforeach; ?>
  </tbody>
</table>
</div>
<p class="nota">Se muestran como máximo los 500 registros más recientes del período.</p>
<?php require __DIR__ . '/includes/footer.php'; ?>
