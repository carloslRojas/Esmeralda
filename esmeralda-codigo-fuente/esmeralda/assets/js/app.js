// Comportamiento mínimo del sistema (sin librerías externas).
(function () {
  // Confirmación antes de enviar formularios delicados
  document.querySelectorAll('form[data-confirmar]').forEach(function (f) {
    f.addEventListener('submit', function (ev) {
      if (!confirm(f.getAttribute('data-confirmar'))) ev.preventDefault();
    });
  });

  // Sugerencia de categoría según el año de nacimiento
  var fecha = document.getElementById('fecha_nacimiento');
  var cat = document.getElementById('categoria_id');
  var ayuda = document.getElementById('sugerencia');
  function sugerir() {
    if (!fecha || !cat || !fecha.value) return;
    var edad = new Date().getFullYear() - parseInt(fecha.value.substring(0, 4), 10);
    var encontrada = null;
    Array.prototype.forEach.call(cat.options, function (o) {
      if (o.dataset.min && edad >= +o.dataset.min && edad <= +o.dataset.max && !encontrada) encontrada = o;
    });
    if (ayuda) {
      ayuda.textContent = encontrada
        ? 'Edad deportiva: ' + edad + ' años → sugerida: ' + encontrada.text.split(' (')[0]
        : 'Edad deportiva: ' + edad + ' años → no hay categoría para esa edad';
    }
    if (encontrada && cat.value === '') encontrada.selected = true;
  }
  if (fecha) {
    fecha.addEventListener('change', function () { if (cat) cat.value = ''; sugerir(); });
    sugerir();
  }

  // Autocompletar representante por cédula
  var repCed = document.getElementById('rep_cedula');
  var repEstado = document.getElementById('rep_estado');
  if (repCed) {
    repCed.addEventListener('blur', function () {
      var v = repCed.value.trim();
      if (v.length < 5) return;
      fetch('rep_buscar.php?cedula=' + encodeURIComponent(v), { credentials: 'same-origin' })
        .then(function (r) { return r.json(); })
        .then(function (d) {
          if (!d || !d.cedula) {
            if (repEstado) repEstado.textContent = 'Representante nuevo: complete sus datos.';
            return;
          }
          ['nombres', 'apellidos', 'parentesco', 'telefono', 'telefono_alt', 'correo', 'direccion', 'ocupacion'].forEach(function (k) {
            var el = document.getElementById('rep_' + k);
            if (el && d[k] !== null) el.value = d[k];
          });
          if (repEstado) repEstado.textContent = 'Representante ya registrado (' + d.hijos + ' jugador(es) a su cargo). Datos cargados.';
        })
        .catch(function () {});
    });
  }
})();
