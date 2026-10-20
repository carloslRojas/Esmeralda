<?php
require_once __DIR__ . '/includes/init.php';
requiere_login();
$titulo = 'Representantes';
$menu = 'representantes';

$b = trim($_GET['b'] ?? '');
$params = [];
$where = '';
if ($b !== '') {
    $where = "WHERE CONCAT(r.nombres,' ',r.apellidos) LIKE ? OR r.cedula LIKE ? OR r.telefono LIKE ?";
    $params = ["%$b%", "%$b%", "%$b%"];
}
$reps = q("SELECT r.*,
                  (SELECT COUNT(*) FROM jugadores j WHERE j.representante_id = r.id) jugadores,
                  (SELECT GROUP_CONCAT(CONCAT(j.nombres,' ',j.apellidos) ORDER BY j.nombres SEPARATOR ', ')
                     FROM jugadores j WHERE j.representante_id = r.id) nombres_jug
           FROM representantes r
           $where ORDER BY r.apellidos, r.nombres LIMIT 300", $params)->fetchAll();

require __DIR__ . '/includes/header.php';
?>
<form class="filtros" method="get">
  <input type="search" name="b" value="<?= e($b) ?>" placeholder="Buscar por nombre, cédula o teléfono">
  <button class="btn">Buscar</button>
  <?php if (puede_editar()): ?><a class="btn btn-primario" href="representante_form.php">+ Nuevo representante</a><?php endif; ?>
</form>
<p class="nota">Los representantes también se registran automáticamente al inscribir un jugador.</p>
<div class="tabla-envoltura">
<table class="tabla">
  <thead><tr><th>Representante</th><th>Cédula</th><th>Parentesco</th><th>Teléfono</th><th>Jugadores a cargo</th><th></th></tr></thead>
  <tbody>
  <?php if (!$reps): ?><tr><td colspan="6" class="vacio">No hay representantes registrados.</td></tr><?php endif; ?>
  <?php foreach ($reps as $r): ?>
    <tr>
      <td><strong><?= e($r['apellidos']) ?></strong>, <?= e($r['nombres']) ?></td>
      <td><?= e($r['cedula']) ?></td>
      <td><?= e($r['parentesco']) ?></td>
      <td><?= e($r['telefono']) ?><?= $r['telefono_alt'] ? '<br><small>' . e($r['telefono_alt']) . '</small>' : '' ?></td>
      <td><?= (int) $r['jugadores'] ?> <?= $r['nombres_jug'] ? '<br><small>' . e($r['nombres_jug']) . '</small>' : '' ?></td>
      <td class="acciones"><?php if (puede_editar()): ?><a href="representante_form.php?id=<?= $r['id'] ?>">Editar</a><?php endif; ?></td>
    </tr>
  <?php endforeach; ?>
  </tbody>
</table>
</div>
<?php require __DIR__ . '/includes/footer.php'; ?>
