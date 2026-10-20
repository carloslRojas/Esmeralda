<?php
require_once __DIR__ . '/includes/init.php';
requiere_login();
$titulo = 'Panel principal';
$menu = 'panel';

$tot = q("SELECT COUNT(*) total,
                 SUM(estado='activo') activos,
                 SUM(estado='activo' AND sexo='M') varones,
                 SUM(estado='activo' AND sexo='F') hembras,
                 SUM(estado='inactivo') inactivos,
                 SUM(estado='lesionado') lesionados
          FROM jugadores")->fetch();
$reps = (int) q('SELECT COUNT(*) FROM representantes')->fetchColumn();
$mes  = (int) q("SELECT COUNT(*) FROM jugadores WHERE fecha_inscripcion >= DATE_FORMAT(CURDATE(), '%Y-%m-01')")->fetchColumn();

$porCat = q("SELECT c.id, c.nombre, c.horario, COUNT(j.id) total
             FROM categorias c
             LEFT JOIN jugadores j ON j.categoria_id = c.id AND j.estado = 'activo'
             GROUP BY c.id, c.nombre, c.horario, c.edad_min
             ORDER BY c.edad_min")->fetchAll();
$sinCat = (int) q("SELECT COUNT(*) FROM jugadores WHERE categoria_id IS NULL AND estado='activo'")->fetchColumn();
$max = max(1, ...array_map(fn($c) => (int) $c['total'], $porCat ?: [['total' => 1]]));

$recientes = q("SELECT j.id, j.nombres, j.apellidos, j.fecha_inscripcion, c.nombre categoria
                FROM jugadores j LEFT JOIN categorias c ON c.id = j.categoria_id
                ORDER BY j.id DESC LIMIT 6")->fetchAll();

require __DIR__ . '/includes/header.php';
?>
<section class="tarjetas">
  <div class="tarjeta"><span>Jugadores activos</span><strong><?= (int) $tot['activos'] ?></strong><small>de <?= (int) $tot['total'] ?> registrados · <a href="jugadores.php?estado=activo">Ver activos</a></small></div>
  <div class="tarjeta"><span>Varones / Hembras</span><strong><?= (int) $tot['varones'] ?> / <?= (int) $tot['hembras'] ?></strong><small>jugadores activos</small></div>
  <div class="tarjeta tarjeta-inactivo" style="border-top-color: var(--ambar);"><span>Jugadores inactivos</span><strong style="color: var(--ambar);"><?= (int) $tot['inactivos'] ?></strong><small><a href="jugadores.php?estado=inactivo">Ver inactivos</a></small></div>
  <div class="tarjeta tarjeta-lesionado" style="border-top-color: var(--rojo);"><span>Jugadores lesionados</span><strong style="color: var(--rojo);"><?= (int) $tot['lesionados'] ?></strong><small><a href="jugadores.php?estado=lesionado">Ver lesionados</a></small></div>
  <div class="tarjeta"><span>Representantes</span><strong><?= $reps ?></strong><small>registrados · <a href="representantes.php">Ver representantes</a></small></div>
  <div class="tarjeta"><span>Inscritos este mes</span><strong><?= $mes ?></strong><small><?= date('m/Y') ?></small></div>
</section>

<div class="rejilla-2">
  <section class="panel">
    <h2>Jugadores activos por categoría</h2>
    <?php foreach ($porCat as $c): ?>
      <a class="barra-cat" href="jugadores.php?categoria=<?= (int) $c['id'] ?>">
        <span class="nombre"><?= e($c['nombre']) ?></span>
        <span class="pista"><span class="relleno" style="width:<?= round($c['total'] / $max * 100) ?>%"></span></span>
        <span class="valor"><?= (int) $c['total'] ?></span>
      </a>
    <?php endforeach; ?>
    <?php if ($sinCat): ?><p class="nota">Hay <?= $sinCat ?> jugador(es) activo(s) sin categoría asignada.</p><?php endif; ?>
  </section>

  <section class="panel">
    <h2>Últimos inscritos</h2>
    <?php if (!$recientes): ?>
      <p class="vacio">Aún no hay jugadores. <?php if (puede_editar()): ?><a href="jugador_form.php">Registrar el primero</a><?php endif; ?></p>
    <?php else: ?>
      <table class="tabla">
        <tbody>
        <?php foreach ($recientes as $r): ?>
          <tr>
            <td><a href="jugador_ver.php?id=<?= (int) $r['id'] ?>"><?= e($r['apellidos'] . ', ' . $r['nombres']) ?></a></td>
            <td><?= e($r['categoria'] ?? '—') ?></td>
            <td class="der"><?= fecha_ve($r['fecha_inscripcion']) ?></td>
          </tr>
        <?php endforeach; ?>
        </tbody>
      </table>
    <?php endif; ?>
    <?php if (puede_editar()): ?><p><a class="btn btn-primario" href="jugador_form.php">+ Nuevo jugador</a></p><?php endif; ?>
  </section>
</div>
<?php require __DIR__ . '/includes/footer.php'; ?>
