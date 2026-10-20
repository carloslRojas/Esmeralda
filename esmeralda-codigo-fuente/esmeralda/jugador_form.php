<?php
require_once __DIR__ . '/includes/init.php';
requiere_rol('secretaria');
$menu = 'jugadores';

$id = (int) ($_GET['id'] ?? 0);
$jugador = null;
$rep = null;
if ($id) {
    $jugador = q('SELECT * FROM jugadores WHERE id = ?', [$id])->fetch();
    if (!$jugador) {
        flash('error', 'El jugador no existe.');
        redirigir('jugadores.php');
    }
    if ($jugador['representante_id']) {
        $rep = q('SELECT * FROM representantes WHERE id = ?', [$jugador['representante_id']])->fetch();
    }
}
$titulo = $id ? 'Editar jugador' : 'Nuevo jugador';

$POS    = ['Por definir', 'Portero', 'Defensa', 'Mediocampista', 'Delantero'];
$PIE    = ['Derecho', 'Izquierdo', 'Ambos'];
$SANGRE = ['No sabe', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
$PAREN  = ['Madre', 'Padre', 'Abuelo(a)', 'Tío(a)', 'Hermano(a)', 'Tutor legal', 'Otro'];
$TALLAS = ['', '4', '6', '8', '10', '12', '14', '16', 'XS', 'S', 'M', 'L', 'XL'];

$errores = [];
$d = $jugador ?? ['fecha_inscripcion' => date('Y-m-d'), 'estado' => 'activo', 'sexo' => 'M',
                  'posicion' => 'Por definir', 'pie_dominante' => 'Derecho', 'tipo_sangre' => 'No sabe'];
$r = $rep ?? ['parentesco' => 'Madre'];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    csrf_verificar();

    $campos = ['cedula', 'nombres', 'apellidos', 'fecha_nacimiento', 'sexo', 'lugar_nacimiento', 'direccion', 'telefono',
               'institucion_educativa', 'grado', 'posicion', 'pie_dominante', 'numero_camiseta', 'talla_camisa',
               'tipo_sangre', 'alergias', 'condicion_medica', 'peso', 'estatura', 'categoria_id', 'fecha_inscripcion',
               'estado', 'observaciones'];
    foreach ($campos as $c) {
        $d[$c] = post($c);
    }
    $camposRep = ['cedula', 'nombres', 'apellidos', 'parentesco', 'telefono', 'telefono_alt', 'correo', 'direccion', 'ocupacion'];
    foreach ($camposRep as $c) {
        $r[$c] = post('rep_' . $c);
    }

    // Normalizar cédulas: sólo letras V/E, dígitos y guion
    $d['cedula'] = limpiar_cedula($d['cedula']);
    $r['cedula'] = limpiar_cedula($r['cedula']);

    // --- Validaciones del jugador ---
    if (!$d['nombres'])   $errores[] = 'Los nombres del jugador son obligatorios.';
    if (!$d['apellidos']) $errores[] = 'Los apellidos del jugador son obligatorios.';
    $fn = DateTime::createFromFormat('Y-m-d', (string) $d['fecha_nacimiento']);
    if (!$fn || $fn->format('Y-m-d') !== $d['fecha_nacimiento']) {
        $errores[] = 'La fecha de nacimiento no es válida.';
    } else {
        $ed = edad($d['fecha_nacimiento']);
        if ($ed < 3 || $ed > 20) $errores[] = "La edad calculada ($ed años) está fuera del rango permitido (3 a 20).";
    }
    if (!in_array($d['sexo'], ['M', 'F'], true))                $errores[] = 'Seleccione el sexo.';
    if (!in_array($d['posicion'], $POS, true))                   $d['posicion'] = 'Por definir';
    if (!in_array($d['pie_dominante'], $PIE, true))              $d['pie_dominante'] = 'Derecho';
    if (!in_array($d['tipo_sangre'], $SANGRE, true))             $d['tipo_sangre'] = 'No sabe';
    if (!in_array($d['estado'], ['activo', 'inactivo', 'lesionado', 'retirado'], true)) $d['estado'] = 'activo';
    if (!DateTime::createFromFormat('Y-m-d', (string) $d['fecha_inscripcion'])) $errores[] = 'La fecha de inscripción no es válida.';
    if ($d['numero_camiseta'] !== null && (!ctype_digit($d['numero_camiseta']) || $d['numero_camiseta'] > 99)) {
        $errores[] = 'El número de camiseta debe estar entre 0 y 99.';
    }
    foreach (['peso' => [5, 150], 'estatura' => [0.5, 2.3]] as $c => [$min, $max]) {
        if ($d[$c] !== null) {
            $d[$c] = str_replace(',', '.', $d[$c]);
            if (!is_numeric($d[$c]) || $d[$c] < $min || $d[$c] > $max) $errores[] = "Valor de $c no válido.";
        }
    }
    if ($d['cedula'] && q('SELECT id FROM jugadores WHERE cedula = ? AND id <> ?', [$d['cedula'], $id])->fetch()) {
        $errores[] = 'Ya existe otro jugador con la cédula ' . $d['cedula'] . '.';
    }

    // --- Validaciones del representante ---
    if (!$r['cedula'])    $errores[] = 'La cédula del representante es obligatoria.';
    if (!$r['nombres'])   $errores[] = 'Los nombres del representante son obligatorios.';
    if (!$r['apellidos']) $errores[] = 'Los apellidos del representante son obligatorios.';
    if (!$r['telefono'])  $errores[] = 'El teléfono del representante es obligatorio.';
    if ($r['correo'] && !filter_var($r['correo'], FILTER_VALIDATE_EMAIL)) $errores[] = 'El correo del representante no es válido.';
    if (!in_array($r['parentesco'], $PAREN, true)) $r['parentesco'] = 'Otro';

    // Categoría: la elegida o la sugerida por edad
    if ($d['categoria_id'] === null && !$errores) {
        $d['categoria_id'] = categoria_sugerida($d['fecha_nacimiento']);
    }

    // Foto
    $nuevaFoto = null;
    if (!$errores) {
        try {
            $nuevaFoto = subir_foto('foto');
        } catch (RuntimeException $ex) {
            $errores[] = $ex->getMessage();
        }
    }

    if (!$errores) {
        $pdo = db();
        $pdo->beginTransaction();
        try {
            // Representante: se reutiliza si la cédula ya existe (y se actualizan sus datos)
            $repId = q('SELECT id FROM representantes WHERE cedula = ?', [$r['cedula']])->fetchColumn();
            $valsRep = [$r['nombres'], $r['apellidos'], $r['parentesco'], $r['telefono'], $r['telefono_alt'],
                        $r['correo'], $r['direccion'], $r['ocupacion']];
            if ($repId) {
                q('UPDATE representantes SET nombres=?, apellidos=?, parentesco=?, telefono=?, telefono_alt=?, correo=?,
                   direccion=?, ocupacion=? WHERE id=?', [...$valsRep, $repId]);
            } else {
                q('INSERT INTO representantes (nombres, apellidos, parentesco, telefono, telefono_alt, correo, direccion,
                   ocupacion, cedula) VALUES (?,?,?,?,?,?,?,?,?)', [...$valsRep, $r['cedula']]);
                $repId = $pdo->lastInsertId();
            }

            $vals = [];
            foreach ($campos as $c) $vals[] = $d[$c];
            $vals[] = $repId;

            if ($id) {
                $set = implode(', ', array_map(fn($c) => "$c = ?", $campos));
                q("UPDATE jugadores SET $set, representante_id = ? WHERE id = ?", [...$vals, $id]);
                if ($nuevaFoto) {
                    q('UPDATE jugadores SET foto = ? WHERE id = ?', [$nuevaFoto, $id]);
                    if (!empty($jugador['foto']) && is_file(FOTO_DIR . $jugador['foto'])) @unlink(FOTO_DIR . $jugador['foto']);
                }
                bitacora('Editar jugador', "#$id {$d['nombres']} {$d['apellidos']}");
                $mensaje = 'Datos del jugador actualizados.';
            } else {
                $cols = implode(', ', $campos) . ', representante_id, foto, creado_por';
                $marcas = implode(', ', array_fill(0, count($campos) + 3, '?'));
                q("INSERT INTO jugadores ($cols) VALUES ($marcas)", [...$vals, $nuevaFoto, usuario_actual()['id']]);
                $id = (int) $pdo->lastInsertId();
                bitacora('Registrar jugador', "#$id {$d['nombres']} {$d['apellidos']}");
                $mensaje = 'Jugador registrado correctamente.';
            }
            $pdo->commit();
            flash('ok', $mensaje);
            redirigir('jugador_ver.php?id=' . $id);
        } catch (Throwable $ex) {
            $pdo->rollBack();
            if ($nuevaFoto && is_file(FOTO_DIR . $nuevaFoto)) @unlink(FOTO_DIR . $nuevaFoto);
            $errores[] = 'No se pudo guardar: ' . $ex->getMessage();
        }
    }
}

$categorias = q('SELECT id, nombre, edad_min, edad_max FROM categorias ORDER BY edad_min')->fetchAll();
$fotoActual = foto_url($jugador['foto'] ?? null);

function opciones(array $lista, $actual): string
{
    $h = '';
    foreach ($lista as $v) {
        $h .= '<option value="' . e($v) . '"' . ((string) $actual === (string) $v ? ' selected' : '') . '>' . e($v === '' ? '—' : $v) . '</option>';
    }
    return $h;
}

require __DIR__ . '/includes/header.php';
?>
<?php if ($errores): ?>
  <div class="alerta alerta-error"><strong>Revise los siguientes datos:</strong><ul><?php foreach ($errores as $er): ?><li><?= e($er) ?></li><?php endforeach; ?></ul></div>
<?php endif; ?>

<form method="post" enctype="multipart/form-data" class="formulario" id="form-jugador">
  <?= csrf_campo() ?>

  <fieldset>
    <legend>Datos personales del jugador</legend>
    <div class="campos">
      <label>Nombres * <input name="nombres" required maxlength="80" value="<?= e($d['nombres'] ?? '') ?>"></label>
      <label>Apellidos * <input name="apellidos" required maxlength="80" value="<?= e($d['apellidos'] ?? '') ?>"></label>
      <label>Cédula / cédula escolar <input name="cedula" maxlength="20" placeholder="V-30123456" value="<?= e($d['cedula'] ?? '') ?>"></label>
      <label>Fecha de nacimiento * <input type="date" name="fecha_nacimiento" id="fecha_nacimiento" required max="<?= date('Y-m-d') ?>" value="<?= e($d['fecha_nacimiento'] ?? '') ?>"></label>
      <label>Sexo *
        <select name="sexo" required>
          <option value="M" <?= ($d['sexo'] ?? '') === 'M' ? 'selected' : '' ?>>Masculino</option>
          <option value="F" <?= ($d['sexo'] ?? '') === 'F' ? 'selected' : '' ?>>Femenino</option>
        </select>
      </label>
      <label>Lugar de nacimiento <input name="lugar_nacimiento" maxlength="100" placeholder="Maracay, Aragua" value="<?= e($d['lugar_nacimiento'] ?? '') ?>"></label>
      <label class="ancho">Dirección de habitación <input name="direccion" maxlength="255" placeholder="Urb., calle, casa — Municipio Girardot" value="<?= e($d['direccion'] ?? '') ?>"></label>
      <label>Teléfono del jugador <input name="telefono" maxlength="20" placeholder="0412-0000000" value="<?= e($d['telefono'] ?? '') ?>"></label>
      <label>Institución educativa <input name="institucion_educativa" maxlength="120" value="<?= e($d['institucion_educativa'] ?? '') ?>"></label>
      <label>Grado / año <input name="grado" maxlength="30" placeholder="5to grado" value="<?= e($d['grado'] ?? '') ?>"></label>
    </div>
  </fieldset>

  <fieldset>
    <legend>Datos deportivos</legend>
    <div class="campos">
      <label>Categoría
        <select name="categoria_id" id="categoria_id">
          <option value="">Automática según la edad</option>
          <?php foreach ($categorias as $c): ?>
            <option value="<?= $c['id'] ?>" data-min="<?= $c['edad_min'] ?>" data-max="<?= $c['edad_max'] ?>"
              <?= (string) ($d['categoria_id'] ?? '') === (string) $c['id'] ? 'selected' : '' ?>><?= e($c['nombre']) ?> (<?= $c['edad_min'] ?>–<?= $c['edad_max'] ?> años)</option>
          <?php endforeach; ?>
        </select>
        <small id="sugerencia" class="ayuda"></small>
      </label>
      <label>Posición <select name="posicion"><?= opciones($POS, $d['posicion'] ?? '') ?></select></label>
      <label>Pie dominante <select name="pie_dominante"><?= opciones($PIE, $d['pie_dominante'] ?? '') ?></select></label>
      <label>N° de camiseta <input type="number" name="numero_camiseta" min="0" max="99" value="<?= e($d['numero_camiseta'] ?? '') ?>"></label>
      <label>Talla de camisa <select name="talla_camisa"><?= opciones($TALLAS, $d['talla_camisa'] ?? '') ?></select></label>
      <label>Fecha de inscripción * <input type="date" name="fecha_inscripcion" required value="<?= e($d['fecha_inscripcion'] ?? date('Y-m-d')) ?>"></label>
      <label>Estado
        <select name="estado">
          <?php foreach (['activo', 'inactivo', 'lesionado', 'retirado'] as $es): ?>
            <option value="<?= $es ?>" <?= ($d['estado'] ?? '') === $es ? 'selected' : '' ?>><?= ucfirst($es) ?></option>
          <?php endforeach; ?>
        </select>
      </label>
    </div>
  </fieldset>

  <fieldset>
    <legend>Datos médicos</legend>
    <div class="campos">
      <label>Tipo de sangre <select name="tipo_sangre"><?= opciones($SANGRE, $d['tipo_sangre'] ?? '') ?></select></label>
      <label>Peso (kg) <input name="peso" inputmode="decimal" placeholder="35.5" value="<?= e($d['peso'] ?? '') ?>"></label>
      <label>Estatura (m) <input name="estatura" inputmode="decimal" placeholder="1.40" value="<?= e($d['estatura'] ?? '') ?>"></label>
      <label class="ancho">Alergias <input name="alergias" maxlength="255" placeholder="Ninguna conocida" value="<?= e($d['alergias'] ?? '') ?>"></label>
      <label class="ancho">Condición médica / medicamentos <input name="condicion_medica" maxlength="255" placeholder="Asma, lentes, etc." value="<?= e($d['condicion_medica'] ?? '') ?>"></label>
    </div>
  </fieldset>

  <fieldset>
    <legend>Representante</legend>
    <p class="ayuda">Escriba la cédula: si el representante ya está registrado (por ejemplo, tiene otro hijo en la escuela), sus datos se cargan solos.</p>
    <div class="campos">
      <label>Cédula * <input name="rep_cedula" id="rep_cedula" required maxlength="15" placeholder="V-12345678" value="<?= e($r['cedula'] ?? '') ?>"><small id="rep_estado" class="ayuda"></small></label>
      <label>Nombres * <input name="rep_nombres" id="rep_nombres" required maxlength="80" value="<?= e($r['nombres'] ?? '') ?>"></label>
      <label>Apellidos * <input name="rep_apellidos" id="rep_apellidos" required maxlength="80" value="<?= e($r['apellidos'] ?? '') ?>"></label>
      <label>Parentesco <select name="rep_parentesco" id="rep_parentesco"><?= opciones($PAREN, $r['parentesco'] ?? '') ?></select></label>
      <label>Teléfono * <input name="rep_telefono" id="rep_telefono" required maxlength="20" placeholder="0414-0000000" value="<?= e($r['telefono'] ?? '') ?>"></label>
      <label>Teléfono alterno <input name="rep_telefono_alt" id="rep_telefono_alt" maxlength="20" value="<?= e($r['telefono_alt'] ?? '') ?>"></label>
      <label>Correo <input type="email" name="rep_correo" id="rep_correo" maxlength="120" value="<?= e($r['correo'] ?? '') ?>"></label>
      <label>Ocupación <input name="rep_ocupacion" id="rep_ocupacion" maxlength="80" value="<?= e($r['ocupacion'] ?? '') ?>"></label>
      <label class="ancho">Dirección <input name="rep_direccion" id="rep_direccion" maxlength="255" value="<?= e($r['direccion'] ?? '') ?>"></label>
    </div>
  </fieldset>

  <fieldset>
    <legend>Foto y observaciones</legend>
    <div class="campos">
      <label>Foto (JPG/PNG, máx. 2 MB)
        <input type="file" name="foto" accept="image/jpeg,image/png,image/webp">
        <?php if ($fotoActual): ?><img src="<?= e($fotoActual) ?>" class="foto-mini" alt="Foto actual"><?php endif; ?>
      </label>
      <label class="ancho">Observaciones <textarea name="observaciones" rows="3"><?= e($d['observaciones'] ?? '') ?></textarea></label>
    </div>
  </fieldset>

  <div class="botones">
    <button class="btn btn-primario">Guardar</button>
    <a class="btn btn-sec" href="<?= $id ? 'jugador_ver.php?id=' . $id : 'jugadores.php' ?>">Cancelar</a>
  </div>
</form>
<?php require __DIR__ . '/includes/footer.php'; ?>
