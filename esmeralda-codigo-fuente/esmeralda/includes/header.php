<?php
/** Encabezado y menú lateral. Requiere $titulo y (opcional) $menu antes de incluirlo. */
$sesion = requiere_login();
$menu = $menu ?? '';
$opciones = [
    'panel'           => ['index.php',          'Panel',           'entrenador'],
    'jugadores'       => ['jugadores.php',      'Jugadores',       'entrenador'],
    'representantes'  => ['representantes.php', 'Representantes',  'entrenador'],
    'categorias'      => ['categorias.php',     'Categorías',      'entrenador'],
    'reportes'        => ['reportes.php',       'Reportes',        'entrenador'],
    'usuarios'        => ['usuarios.php',       'Usuarios',        'administrador'],
    'bitacora'        => ['bitacora.php',       'Bitácora',        'administrador'],
];
?><!DOCTYPE html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><?= e($titulo ?? 'Inicio') ?> · <?= e(APP_SIGLAS) ?></title>
<link rel="stylesheet" href="assets/css/estilos.css">
</head>
<body>
<input type="checkbox" id="menu-toggle" hidden>
<aside class="lateral no-imprimir">
  <div class="marca">
    <svg viewBox="0 0 40 40" width="38" height="38" aria-hidden="true">
      <path d="M20 2 L36 8 V20 C36 30 28 36 20 38 C12 36 4 30 4 20 V8 Z" fill="#0f7a4f" stroke="#e9c46a" stroke-width="2"/>
      <circle cx="20" cy="20" r="8" fill="#fff"/>
      <path d="M20 14 l4 3 -1.5 5 h-5 L16 17 z" fill="#0f7a4f"/>
    </svg>
    <div><strong>La Esmeralda</strong><small>Escuela de Fútbol</small></div>
  </div>
  <nav>
    <?php foreach ($opciones as $clave => [$url, $texto, $rol]): if (!tiene_rol($rol)) continue; ?>
      <a href="<?= $url ?>" class="<?= $menu === $clave ? 'activo' : '' ?>"><?= e($texto) ?></a>
    <?php endforeach; ?>
  </nav>
  <div class="sesion">
    <span><?= e($sesion['nombre']) ?></span>
    <small><?= e(ucfirst($sesion['rol'])) ?></small>
    <a href="perfil.php">Cambiar clave</a> · <a href="logout.php">Salir</a>
  </div>
</aside>
<main class="contenido">
  <header class="barra no-imprimir">
    <label for="menu-toggle" class="btn-menu" aria-label="Menú">☰</label>
    <h1><?= e($titulo ?? '') ?></h1>
  </header>
  <?= mostrar_flash() ?>
