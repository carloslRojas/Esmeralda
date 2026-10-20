<?php
require_once __DIR__ . '/includes/init.php';
if (usuario_actual()) {
    bitacora('Cierre de sesión', 'Usuario ' . usuario_actual()['usuario']);
}
$_SESSION = [];
session_destroy();
redirigir('login.php');
