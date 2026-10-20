<?php
/** Devuelve en JSON los datos de un representante por cédula (usado por el formulario de jugador). */
require_once __DIR__ . '/includes/init.php';
header('Content-Type: application/json; charset=utf-8');
if (!usuario_actual()) {
    http_response_code(401);
    exit('{}');
}
$ced = limpiar_cedula($_GET['cedula'] ?? '');
$rep = $ced ? q('SELECT r.cedula, r.nombres, r.apellidos, r.parentesco, r.telefono, r.telefono_alt, r.correo, r.direccion,
                        r.ocupacion, (SELECT COUNT(*) FROM jugadores j WHERE j.representante_id = r.id) hijos
                 FROM representantes r WHERE r.cedula = ?', [$ced])->fetch() : false;
echo json_encode($rep ?: new stdClass(), JSON_UNESCAPED_UNICODE);
