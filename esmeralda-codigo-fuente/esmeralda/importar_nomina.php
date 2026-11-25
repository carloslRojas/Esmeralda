<?php
require_once __DIR__ . '/includes/init.php';
requiere_rol('secretaria');
$titulo = 'Importar nómina';
$menu = 'jugadores';

const NOMINA_OFICIAL_ARCHIVO = __DIR__ . '/database/nomina_2026_11_03.csv';
const NOMINA_OFICIAL_FECHA   = '2026-11-03';

function normalizar_texto_nombre(string $s): string
{
    $s = trim(preg_replace('/\s+/u', ' ', $s));
    if ($s === '') return '';
    $t = mb_convert_case(mb_strtolower($s, 'UTF-8'), MB_CASE_TITLE, 'UTF-8');
    return preg_replace_callback('/(?<=\s)(De|Del|La|Las|Los|Y)(?=\s)/u', fn($m) => mb_strtolower($m[1], 'UTF-8'), $t);
}

function normalizar_fecha_nomina(string $raw): ?string
{
    $raw = trim($raw);
    if ($raw === '') return null;
    if (preg_match('/^(\d{4})[-\/](\d{2})[-\/](\d{2})$/', $raw, $m)) {
        $y = (int) $m[1]; $mo = (int) $m[2]; $d = (int) $m[3];
    } elseif (preg_match('/^(\d{2})[-\/](\d{2})[-\/](\d{4})$/', $raw, $m)) {
        $d = (int) $m[1]; $mo = (int) $m[2]; $y = (int) $m[3];
    } elseif (preg_match('/^(\d{2})[-\/](\d{2})[-\/](\d{2})$/', $raw, $m)) {
        $d = (int) $m[1]; $mo = (int) $m[2]; $y = 2000 + (int) $m[3];
    } else {
        return null;
    }
    if (!checkdate($mo, $d, $y) || $y < 1995 || $y > (int) date('Y')) {
        return null;
    }
    return sprintf('%04d-%02d-%02d', $y, $mo, $d);
}

function normalizar_cedula_ve(?string $raw): ?string
{
    $c = limpiar_cedula($raw);
    if ($c === null) return null;
    if (preg_match('/^\d+$/', $c)) {
        return 'V-' . $c;
    }
    return $c;
}

function detectar_delimitador(string $ruta): string
{
    $h = fopen($ruta, 'r');
    if (!$h) return ',';
    $muestra = '';
    for ($i = 0; $i < 10 && ($linea = fgets($h)) !== false; $i++) {
        $muestra .= $linea;
    }
    fclose($h);
    return substr_count($muestra, ';') > substr_count($muestra, ',') ? ';' : ',';
}

function leer_filas_nomina(string $ruta): array
{
    $delim = detectar_delimitador($ruta);
    $h = fopen($ruta, 'r');
    if (!$h) {
        throw new RuntimeException('No se pudo abrir el archivo CSV.');
    }

    $mapa = null;
    $registros = [];
    $numLinea = 0;

    while (($fila = fgetcsv($h, 0, $delim, '"', '\\')) !== false) {
        $numLinea++;
        if ($numLinea === 1 && isset($fila[0])) {
            $fila[0] = preg_replace('/^\xEF\xBB\xBF/', '', (string) $fila[0]);
        }

        $limpias = array_map(fn($v) => trim((string) $v), $fila);
        $vacia = true;
        foreach ($limpias as $c) {
            if ($c !== '') { $vacia = false; break; }
        }
        if ($vacia) continue;

        if ($mapa === null) {
            $upper = array_map(fn($v) => mb_strtoupper($v, 'UTF-8'), $limpias);
            $idxNom = array_search('NOMBRES', $upper, true);
            $idxApe = array_search('APELLIDOS', $upper, true);
            if ($idxNom !== false && $idxApe !== false) {
                $mapa = [
                    'sub'     => false,
                    'nombres' => $idxNom,
                    'apellidos' => $idxApe,
                    'fecha'   => false,
                    'sexo'    => false,
                    'ced_rep' => false,
                    'ced_atl' => false,
                ];
                foreach ($upper as $idx => $col) {
                    if ($mapa['sub'] === false && (strpos($col, 'CATEGORIA') !== false || strpos($col, 'CATEGORÍA') !== false || $col === 'SUB')) $mapa['sub'] = $idx;
                    if ($mapa['fecha'] === false && strpos($col, 'FECHA') !== false) $mapa['fecha'] = $idx;
                    if ($mapa['sexo'] === false && $col === 'SEXO') $mapa['sexo'] = $idx;
                    if ($mapa['ced_rep'] === false && strpos($col, 'REPRESENTANTE') !== false) $mapa['ced_rep'] = $idx;
                    if ($mapa['ced_atl'] === false && (strpos($col, 'ATLETA') !== false || $col === 'CEDULA' || $col === 'CÉDULA')) $mapa['ced_atl'] = $idx;
                }
            }
            continue;
        }

        $nombres   = normalizar_texto_nombre($limpias[$mapa['nombres']] ?? '');
        $apellidos = normalizar_texto_nombre($limpias[$mapa['apellidos']] ?? '');
        $fecha     = $mapa['fecha'] !== false ? normalizar_fecha_nomina($limpias[$mapa['fecha']] ?? '') : null;

        // Ignorar filas auxiliares/no válidas (ej. totales o notas al final de la hoja)
        if ($nombres === '' || $apellidos === '' || $fecha === null) {
            continue;
        }

        $subRaw = $mapa['sub'] !== false ? ($limpias[$mapa['sub']] ?? '') : '';
        $subNum = preg_replace('/[^0-9]/', '', $subRaw);
        $categoria = $subNum !== '' ? 'Sub-' . (int) $subNum : null;

        $sexoRaw = $mapa['sexo'] !== false ? strtoupper($limpias[$mapa['sexo']] ?? '') : '';
        $sexo = in_array($sexoRaw, ['M', 'F'], true) ? $sexoRaw : 'M';

        $cedRep = $mapa['ced_rep'] !== false ? normalizar_cedula_ve($limpias[$mapa['ced_rep']] ?? '') : null;
        $cedAtl = $mapa['ced_atl'] !== false ? normalizar_cedula_ve($limpias[$mapa['ced_atl']] ?? '') : null;

        $registros[] = [
            'categoria'        => $categoria,
            'nombres'          => $nombres,
            'apellidos'        => $apellidos,
            'fecha_nacimiento' => $fecha,
            'sexo'             => $sexo,
            'ced_rep'          => $cedRep,
            'ced_atl'          => $cedAtl,
        ];
    }
    fclose($h);

    if ($mapa === null) {
        throw new RuntimeException('No se encontró la fila de encabezados (NOMBRES, APELLIDOS) en el archivo CSV.');
    }
    return $registros;
}

function importar_registros_nomina(array $registros, string $fechaInscripcion, string $notaOrigen): array
{
    $pdo = db();
    $pdo->beginTransaction();
    $insertados = 0;
    $omitidos   = 0;
    $repsNuevos = 0;

    try {
        // Asegurar categoría Sub-20 si hace falta
        $cats = [];
        foreach (q('SELECT id, nombre FROM categorias')->fetchAll() as $c) {
            $cats[mb_strtolower($c['nombre'], 'UTF-8')] = (int) $c['id'];
        }

        $userId = usuario_actual()['id'] ?? null;

        foreach ($registros as $reg) {
            // Resolver categoría
            $catId = null;
            if ($reg['categoria'] !== null) {
                $claveCat = mb_strtolower($reg['categoria'], 'UTF-8');
                if (!isset($cats[$claveCat])) {
                    $num = (int) preg_replace('/[^0-9]/', '', $reg['categoria']);
                    $eMax = max(5, min(20, $num - 1));
                    $eMin = max(3, $eMax - 1);
                    q('INSERT INTO categorias (nombre, edad_min, edad_max, horario, descripcion) VALUES (?, ?, ?, ?, ?)',
                      [$reg['categoria'], $eMin, $eMax, 'Por definir', 'Categoría ' . $reg['categoria']]);
                    $cats[$claveCat] = (int) $pdo->lastInsertId();
                }
                $catId = $cats[$claveCat];
            } else {
                $catId = categoria_sugerida($reg['fecha_nacimiento']);
            }

            // Verificar si el jugador ya existe (por cédula o por nombres + apellidos + fecha de nacimiento)
            $existe = false;
            if ($reg['ced_atl'] !== null) {
                $existe = (bool) q('SELECT id FROM jugadores WHERE cedula = ? LIMIT 1', [$reg['ced_atl']])->fetchColumn();
            }
            if (!$existe) {
                $existe = (bool) q(
                    'SELECT id FROM jugadores WHERE nombres = ? AND apellidos = ? AND fecha_nacimiento = ? LIMIT 1',
                    [$reg['nombres'], $reg['apellidos'], $reg['fecha_nacimiento']]
                )->fetchColumn();
            }
            if ($existe) {
                $omitidos++;
                continue;
            }

            // Resolver representante si trae cédula de representante
            $repId = null;
            if ($reg['ced_rep'] !== null) {
                $repId = q('SELECT id FROM representantes WHERE cedula = ? LIMIT 1', [$reg['ced_rep']])->fetchColumn();
                if ($repId) {
                    $repId = (int) $repId;
                } else {
                    q(
                        'INSERT INTO representantes (cedula, nombres, apellidos, parentesco, telefono) VALUES (?, ?, ?, ?, ?)',
                        [$reg['ced_rep'], 'Representante', $reg['apellidos'], 'Otro', 'Por completar']
                    );
                    $repId = (int) $pdo->lastInsertId();
                    $repsNuevos++;
                }
            }

            q(
                'INSERT INTO jugadores (cedula, nombres, apellidos, fecha_nacimiento, sexo, categoria_id, representante_id, fecha_inscripcion, estado, observaciones, creado_por)
                 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
                [
                    $reg['ced_atl'],
                    $reg['nombres'],
                    $reg['apellidos'],
                    $reg['fecha_nacimiento'],
                    $reg['sexo'],
                    $catId,
                    $repId,
                    $fechaInscripcion,
                    'activo',
                    $notaOrigen,
                    $userId,
                ]
            );
            $insertados++;
        }

        $pdo->commit();
    } catch (Throwable $ex) {
        $pdo->rollBack();
        throw $ex;
    }

    return ['insertados' => $insertados, 'omitidos' => $omitidos, 'reps_nuevos' => $repsNuevos];
}

$errores = [];
$tieneOficial = is_file(NOMINA_OFICIAL_ARCHIVO);

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    csrf_verificar();
    $modo = $_POST['modo'] ?? '';

    try {
        if ($modo === 'oficial') {
            if (!$tieneOficial) {
                throw new RuntimeException('No se encontró el archivo interno de la nómina oficial.');
            }
            $registros = leer_filas_nomina(NOMINA_OFICIAL_ARCHIVO);
            $res = importar_registros_nomina($registros, NOMINA_OFICIAL_FECHA, 'Nómina de atletas activos al 03/11/2026');
            bitacora('Importar nómina', "Oficial 03/11/2026: {$res['insertados']} nuevos, {$res['omitidos']} omitidos");
            flash('ok', "Nómina oficial procesada: {$res['insertados']} jugador(es) registrado(s), {$res['omitidos']} ya existente(s), {$res['reps_nuevos']} representante(s) creado(s).");
            redirigir('jugadores.php');
        } elseif ($modo === 'csv') {
            if (empty($_FILES['archivo_csv']) || $_FILES['archivo_csv']['error'] === UPLOAD_ERR_NO_FILE) {
                throw new RuntimeException('Seleccione un archivo CSV para importar.');
            }
            $f = $_FILES['archivo_csv'];
            if ($f['error'] !== UPLOAD_ERR_OK) {
                throw new RuntimeException('No se pudo subir el archivo (código ' . $f['error'] . ').');
            }
            if ($f['size'] > 2 * 1024 * 1024) {
                throw new RuntimeException('El archivo CSV supera el máximo permitido de 2 MB.');
            }
            $ext = strtolower(pathinfo((string) $f['name'], PATHINFO_EXTENSION));
            if ($ext !== 'csv' && $ext !== 'txt') {
                throw new RuntimeException('El archivo debe tener extensión .csv.');
            }
            $registros = leer_filas_nomina($f['tmp_name']);
            if (!$registros) {
                throw new RuntimeException('No se encontraron filas de atletas válidas en el CSV.');
            }
            $fechaInsc = post('fecha_inscripcion') ?: date('Y-m-d');
            if (!DateTime::createFromFormat('Y-m-d', $fechaInsc)) {
                $fechaInsc = date('Y-m-d');
            }
            $res = importar_registros_nomina($registros, $fechaInsc, 'Importado desde CSV (' . date('d/m/Y') . ')');
            bitacora('Importar nómina', "CSV ({$f['name']}): {$res['insertados']} nuevos, {$res['omitidos']} omitidos");
            flash('ok', "Archivo procesado: {$res['insertados']} jugador(es) registrado(s), {$res['omitidos']} ya existente(s), {$res['reps_nuevos']} representante(s) creado(s).");
            redirigir('jugadores.php');
        } else {
            $errores[] = 'Acción de importación no reconocida.';
        }
    } catch (Throwable $ex) {
        $errores[] = $ex->getMessage();
    }
}

$totalActual = (int) q('SELECT COUNT(*) FROM jugadores')->fetchColumn();
$oficialTotal = 0;
if ($tieneOficial) {
    try {
        $oficialTotal = count(leer_filas_nomina(NOMINA_OFICIAL_ARCHIVO));
    } catch (Throwable $ex) {
        $oficialTotal = 0;
    }
}

require __DIR__ . '/includes/header.php';
?>
<div class="botones">
  <a class="btn btn-sec" href="jugadores.php">← Volver a jugadores</a>
</div>

<?php if ($errores): ?>
  <div class="alerta alerta-error"><ul><?php foreach ($errores as $er): ?><li><?= e($er) ?></li><?php endforeach; ?></ul></div>
<?php endif; ?>

<div class="rejilla-2">
  <?php if ($tieneOficial): ?>
  <section class="panel">
    <h2>Nómina oficial de atletas activos (03/11/2026)</h2>
    <p>Incluye los <strong><?= $oficialTotal ?> atletas activos</strong> de la Escuela Comunitaria de Fútbol «La Esmeralda» (categorías Sub-8 a Sub-20).</p>
    <p class="nota">Actualmente hay <strong><?= $totalActual ?></strong> jugador(es) en el sistema. Si un jugador ya está registrado (por cédula o nombre y fecha de nacimiento), se omitirá automáticamente sin crear duplicados.</p>
    <form method="post" data-confirmar="¿Cargar la nómina oficial del 03/11/2026? Los jugadores ya registrados no se duplicarán.">
      <?= csrf_campo() ?>
      <input type="hidden" name="modo" value="oficial">
      <button class="btn btn-primario">Cargar nómina oficial (<?= $oficialTotal ?> atletas)</button>
    </form>
  </section>
  <?php endif; ?>

  <section class="panel">
    <h2>Importar desde archivo CSV</h2>
    <p>Suba un archivo <code>.csv</code> (separado por comas o punto y coma) con columnas: <code>CATEGORIA SUB</code>, <code>NOMBRES</code>, <code>APELLIDOS</code>, <code>FECHA NACIMIENTO</code>, <code>CEDULA REPRESENTANTE</code>, <code>CEDULA ATLETA</code> (y opcionalmente <code>SEXO</code>).</p>
    <form method="post" enctype="multipart/form-data" class="formulario">
      <?= csrf_campo() ?>
      <input type="hidden" name="modo" value="csv">
      <label>Archivo CSV *
        <input type="file" name="archivo_csv" accept=".csv,text/csv" required>
      </label>
      <label>Fecha de inscripción por defecto
        <input type="date" name="fecha_inscripcion" value="<?= date('Y-m-d') ?>">
      </label>
      <div class="botones">
        <button class="btn btn-primario">Importar CSV</button>
      </div>
    </form>
  </section>
</div>
<?php require __DIR__ . '/includes/footer.php'; ?>
