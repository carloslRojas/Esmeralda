<?php
/** Constancia de inscripción imprimible (página independiente, tamaño carta). */
require_once __DIR__ . '/includes/init.php';
requiere_login();
$id = (int) ($_GET['id'] ?? 0);
$j = q('SELECT j.*, c.nombre categoria, c.horario, r.nombres rn, r.apellidos ra, r.cedula rc, r.parentesco
        FROM jugadores j
        LEFT JOIN categorias c ON c.id = j.categoria_id
        LEFT JOIN representantes r ON r.id = j.representante_id
        WHERE j.id = ?', [$id])->fetch();
if (!$j) {
    exit('Jugador no encontrado.');
}
bitacora('Constancia', "Jugador #$id");
$meses = [1 => 'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];
$hoy = (int) date('j') . ' días del mes de ' . $meses[(int) date('n')] . ' de ' . date('Y');
?><!DOCTYPE html>
<html lang="es">
<head>
<meta charset="utf-8">
<title>Constancia de inscripción · <?= e($j['nombres'] . ' ' . $j['apellidos']) ?></title>
<link rel="stylesheet" href="assets/css/estilos.css">
</head>
<body class="hoja">
  <div class="no-imprimir botones"><button class="btn btn-primario" onclick="window.print()">Imprimir</button></div>
  <div class="membrete">
    <svg viewBox="0 0 40 40" width="60" height="60" aria-hidden="true">
      <path d="M20 2 L36 8 V20 C36 30 28 36 20 38 C12 36 4 30 4 20 V8 Z" fill="#0f7a4f" stroke="#e9c46a" stroke-width="2"/>
      <circle cx="20" cy="20" r="8" fill="#fff"/><path d="M20 14 l4 3 -1.5 5 h-5 L16 17 z" fill="#0f7a4f"/>
    </svg>
    <div>
      <strong>República Bolivariana de Venezuela</strong><br>
      <strong><?= e(mb_strtoupper(APP_NOMBRE)) ?></strong><br>
      <?= e(APP_UBICACION) ?>
    </div>
  </div>

  <h1 class="titulo-constancia">CONSTANCIA DE INSCRIPCIÓN</h1>

  <p class="texto-constancia">
    Quien suscribe, en representación de la <strong><?= e(APP_NOMBRE) ?></strong>, hace constar por medio de la presente
    que el/la jugador(a) <strong><?= e(mb_strtoupper($j['nombres'] . ' ' . $j['apellidos'])) ?></strong>,
    <?= $j['cedula'] ? 'titular de la cédula N° <strong>' . e($j['cedula']) . '</strong>, ' : '' ?>
    nacido(a) el <strong><?= fecha_ve($j['fecha_nacimiento']) ?></strong>, de <?= edad($j['fecha_nacimiento']) ?> años de edad,
    se encuentra <strong><?= $j['estado'] === 'activo' ? 'debidamente inscrito(a)' : 'registrado(a) con estado «' . e($j['estado']) . '»' ?></strong>
    en esta escuela desde el <strong><?= fecha_ve($j['fecha_inscripcion']) ?></strong>, en la categoría
    <strong><?= e($j['categoria'] ?? 'por asignar') ?></strong><?= $j['horario'] ? ', con horario de entrenamiento: ' . e($j['horario']) : '' ?>.
  </p>
  <?php if ($j['rn']): ?>
  <p class="texto-constancia">
    Su representante legal ante esta institución es <strong><?= e($j['rn'] . ' ' . $j['ra']) ?></strong>,
    C.I. <strong><?= e($j['rc']) ?></strong> (<?= e(mb_strtolower($j['parentesco'])) ?>).
  </p>
  <?php endif; ?>
  <p class="texto-constancia">
    Constancia que se expide a solicitud de la parte interesada, en Maracay, a los <?= $hoy ?>.
  </p>

  <div class="firmas">
    <div><span></span>Director(a) / Coordinador(a)<br><?= e(APP_NOMBRE) ?></div>
    <div class="sello">Sello</div>
  </div>
  <p class="nota centro">Código de registro: EFE-<?= str_pad((string) $j['id'], 5, '0', STR_PAD_LEFT) ?></p>
</body>
</html>
