<?php
require_once __DIR__ . '/includes/init.php';
requiere_login();
$titulo = 'Jugadores';
$menu = 'jugadores';

// Filtros
$b         = trim($_GET['b'] ?? '');
$categoria = $_GET['categoria'] ?? '';
$estado    = $_GET['estado'] ?? 'activo';

$where = [];
$params = [];
if ($b !== '') {
    $where[] = "(CONCAT(j.nombres,' ',j.apellidos) LIKE ? OR CONCAT(j.apellidos,' ',j.nombres) LIKE ? OR j.cedula LIKE ? OR r.cedula LIKE ?)";
    array_push($params, "%$b%", "%$b%", "%$b%", "%$b%");
}
if ($categoria === 'sin') {
    $where[] = 'j.categoria_id IS NULL';
} elseif ($categoria !== '') {
    $where[] = 'j.categoria_id = ?';
    $params[] = (int) $categoria;
}
if (in_array($estado, ['activo', 'inactivo', 'lesionado', 'retirado'], true)) {
    $where[] = 'j.estado = ?';
    $params[] = $estado;
}
$sqlWhere = $where ? 'WHERE ' . implode(' AND ', $where) : '';
$base = "FROM jugadores j
         LEFT JOIN categorias c ON c.id = j.categoria_id
         LEFT JOIN representantes r ON r.id = j.representante_id
         $sqlWhere";

// Exportar a Excel (CSV con separador ; y BOM para que Excel respete los acentos)
if (isset($_GET['exportar'])) {
    $filas = q("SELECT j.cedula, j.apellidos, j.nombres, j.fecha_nacimiento, j.sexo, c.nombre categoria, j.posicion,
                       j.tipo_sangre, j.estado, j.fecha_inscripcion,
                       CONCAT(r.nombres,' ',r.apellidos) representante, r.cedula ced_rep, r.telefono
                $base ORDER BY c.edad_min, j.apellidos, j.nombres", $params)->fetchAll();
    bitacora('Exportar', 'Listado de jugadores (' . count($filas) . ')');
    header('Content-Type: text/csv; charset=utf-8');
    header('Content-Disposition: attachment; filename="jugadores_' . date('Ymd') . '.csv"');
    $out = fopen('php://output', 'w');
    fwrite($out, "\xEF\xBB\xBF");
    fputcsv($out, ['Cédula', 'Apellidos', 'Nombres', 'Fecha nac.', 'Edad', 'Sexo', 'Categoría', 'Posición',
                   'Tipo sangre', 'Estado', 'Inscripción', 'Representante', 'C.I. representante', 'Teléfono'], ';');
    foreach ($filas as $f) {
        fputcsv($out, [$f['cedula'], $f['apellidos'], $f['nombres'], fecha_ve($f['fecha_nacimiento']),
                       edad($f['fecha_nacimiento']), $f['sexo'], $f['categoria'], $f['posicion'], $f['tipo_sangre'],
                       $f['estado'], fecha_ve($f['fecha_inscripcion']), $f['representante'], $f['ced_rep'], $f['telefono']], ';');
    }
    exit;
}

// Paginación
$porPagina = 25;
$total = (int) q("SELECT COUNT(*) $base", $params)->fetchColumn();
$paginas = max(1, (int) ceil($total / $porPagina));
$p = min($paginas, max(1, (int) ($_GET['p'] ?? 1)));
$offset = ($p - 1) * $porPagina;

$jugadores = q("SELECT j.*, c.nombre categoria, CONCAT(r.nombres,' ',r.apellidos) representante, r.telefono tel_rep
                $base ORDER BY j.apellidos, j.nombres LIMIT $porPagina OFFSET $offset", $params)->fetchAll();
$categorias = q('SELECT id, nombre FROM categorias ORDER BY edad_min')->fetchAll();

function url_filtros(array $extra = []): string
{
    $q = array_merge(array_intersect_key($_GET, array_flip(['b', 'categoria', 'estado'])), $extra);
    return 'jugadores.php?' . http_build_query($q);
}

function render_tabla_jugadores(array $jugadores, int $total, int $paginas, int $p): void
{
    ?>
    <p class="nota"><?= $total ?> jugador(es) encontrado(s).</p>

    <div class="tabla-envoltura">
    <table class="tabla">
      <thead>
        <tr><th></th><th>Jugador</th><th class="sin-salto" style="white-space:nowrap;">Cédula</th><th>Edad</th><th>Categoría</th><th>Posición</th><th>Representante</th><th>Estado</th><th></th></tr>
      </thead>
      <tbody>
      <?php if (!$jugadores): ?>
        <tr><td colspan="9" class="vacio">No hay jugadores con esos criterios.</td></tr>
      <?php endif; ?>
      <?php foreach ($jugadores as $j): $foto = foto_url($j['foto']); ?>
        <tr>
          <td><?php if ($foto): ?><img class="avatar" src="<?= e($foto) ?>" alt=""><?php else: ?><span class="avatar"><?= e(iniciales($j['nombres'], $j['apellidos'])) ?></span><?php endif; ?></td>
          <td><a href="jugador_ver.php?id=<?= $j['id'] ?>"><strong><?= e($j['apellidos']) ?></strong>, <?= e($j['nombres']) ?></a></td>
          <td class="sin-salto" style="white-space:nowrap;"><?= e($j['cedula'] ?? '—') ?></td>
          <td><?= edad($j['fecha_nacimiento']) ?></td>
          <td><?= e($j['categoria'] ?? '—') ?></td>
          <td><?= e($j['posicion']) ?></td>
          <td><?= e($j['representante'] ?? '—') ?><br><small><?= e($j['tel_rep'] ?? '') ?></small></td>
          <td><span class="etiqueta etiqueta-<?= e($j['estado']) ?>"><?= e(ucfirst($j['estado'])) ?></span></td>
          <td class="acciones">
            <a class="btn-icono btn-mini-ver" href="jugador_ver.php?id=<?= $j['id'] ?>" title="Ver ficha" aria-label="Ver ficha"><svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg></a>
            <?php if (puede_editar()): ?><a class="btn-icono btn-mini-editar" href="jugador_form.php?id=<?= $j['id'] ?>" title="Editar jugador" aria-label="Editar jugador"><svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M12 20h9"/><path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4Z"/></svg></a><?php endif; ?>
          </td>
        </tr>
      <?php endforeach; ?>
      </tbody>
    </table>
    </div>

    <?php if ($paginas > 1): ?>
    <nav class="paginacion">
      <?php for ($i = 1; $i <= $paginas; $i++): ?>
        <a class="<?= $i === $p ? 'activo' : '' ?>" href="<?= e(url_filtros(['p' => $i])) ?>"><?= $i ?></a>
      <?php endfor; ?>
    </nav>
    <?php endif; ?>
    <?php
}

if (isset($_GET['ajax'])) {
    header('Content-Type: text/html; charset=utf-8');
    render_tabla_jugadores($jugadores, $total, $paginas, $p);
    exit;
}

require __DIR__ . '/includes/header.php';
?>
<form class="filtros" method="get" id="form-filtros">
  <input type="search" name="b" id="input-busqueda" value="<?= e($b) ?>" placeholder="Buscar por nombre o cédula (jugador o representante)" autocomplete="off">
  <select name="categoria" id="select-categoria">
    <option value="">Todas las categorías</option>
    <?php foreach ($categorias as $c): ?>
      <option value="<?= $c['id'] ?>" <?= (string) $categoria === (string) $c['id'] ? 'selected' : '' ?>><?= e($c['nombre']) ?></option>
    <?php endforeach; ?>
    <option value="sin" <?= $categoria === 'sin' ? 'selected' : '' ?>>Sin categoría</option>
  </select>
  <select name="estado" id="select-estado">
    <?php foreach (['activo' => 'Activos', 'inactivo' => 'Inactivos', 'lesionado' => 'Lesionados', 'retirado' => 'Retirados', 'todos' => 'Todos'] as $v => $t): ?>
      <option value="<?= $v ?>" <?= $estado === $v ? 'selected' : '' ?>><?= $t ?></option>
    <?php endforeach; ?>
  </select>
  <button class="btn">Filtrar</button>
  <a class="btn btn-sec" id="btn-exportar" href="<?= e(url_filtros(['exportar' => 1])) ?>">Exportar a Excel</a>
  <?php if (puede_editar()): ?><a class="btn btn-primario" href="jugador_form.php">+ Nuevo jugador</a><?php endif; ?>
</form>

<div id="contenedor-jugadores">
  <?php render_tabla_jugadores($jugadores, $total, $paginas, $p); ?>
</div>

<script>
document.addEventListener('DOMContentLoaded', function () {
  var inputB = document.getElementById('input-busqueda');
  var selCat = document.getElementById('select-categoria');
  var selEst = document.getElementById('select-estado');
  var btnExportar = document.getElementById('btn-exportar');
  var contenedor = document.getElementById('contenedor-jugadores');

  if (!inputB || !contenedor) return;

  var debounceTimer = null;
  var abortCtrl = null;

  function actualizar() {
    var b = inputB.value.trim();
    var cat = selCat ? selCat.value : '';
    var est = selEst ? selEst.value : '';

    if (btnExportar) {
      var expParams = new URLSearchParams();
      if (b) expParams.set('b', b);
      if (cat) expParams.set('categoria', cat);
      if (est) expParams.set('estado', est);
      expParams.set('exportar', '1');
      btnExportar.href = 'jugadores.php?' + expParams.toString();
    }

    var urlParams = new URLSearchParams();
    if (b) urlParams.set('b', b);
    if (cat) urlParams.set('categoria', cat);
    if (est) urlParams.set('estado', est);
    var nuevaUrl = 'jugadores.php' + (urlParams.toString() ? '?' + urlParams.toString() : '');
    window.history.replaceState(null, '', nuevaUrl);

    if (abortCtrl) abortCtrl.abort();
    abortCtrl = new AbortController();

    var fetchParams = new URLSearchParams(urlParams);
    fetchParams.set('ajax', '1');

    fetch('jugadores.php?' + fetchParams.toString(), {
      signal: abortCtrl.signal,
      headers: { 'X-Requested-With': 'XMLHttpRequest' }
    })
    .then(function (res) { return res.text(); })
    .then(function (html) {
      contenedor.innerHTML = html;
    })
    .catch(function (err) {
      if (err.name !== 'AbortError') console.error(err);
    });
  }

  inputB.addEventListener('input', function () {
    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(actualizar, 150);
  });

  if (selCat) selCat.addEventListener('change', actualizar);
  if (selEst) selEst.addEventListener('change', actualizar);

  contenedor.addEventListener('click', function (ev) {
    var link = ev.target.closest('.paginacion a');
    if (!link) return;
    ev.preventDefault();
    var href = link.getAttribute('href');
    if (!href) return;
    var url = new URL(href, window.location.href);
    url.searchParams.set('ajax', '1');

    fetch(url.toString(), {
      headers: { 'X-Requested-With': 'XMLHttpRequest' }
    })
    .then(function (res) { return res.text(); })
    .then(function (html) {
      contenedor.innerHTML = html;
      url.searchParams.delete('ajax');
      window.history.replaceState(null, '', url.pathname + '?' + url.searchParams.toString());
    })
    .catch(function (err) { console.error(err); });
  });
});
</script>
<?php require __DIR__ . '/includes/footer.php'; ?>
