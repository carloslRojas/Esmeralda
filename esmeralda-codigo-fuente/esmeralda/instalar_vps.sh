#!/usr/bin/env bash
# =====================================================================
#  Instalador automático — Sistema de Registro de Jugadores
#  Escuela de Fútbol La Esmeralda (Maracay, Venezuela)
#
#  Para: Ubuntu 22.04 / 24.04 (VPS limpio)
#  Instala: Nginx + PHP-FPM + MySQL + la aplicación + firewall + respaldos diarios
#
#  INSTALAR:
#      sudo apt update && sudo apt install -y git
#      git clone https://github.com/jbrojasr/esmeralda.git
#      cd esmeralda && sudo bash instalar_vps.sh
#
#  ACTUALIZAR (conserva jugadores, usuarios y fotos):
#      cd esmeralda && git pull && sudo bash instalar_vps.sh
#
#  Respaldo automático diario: /var/backups/esmeralda
#  Credenciales generadas:     /root/esmeralda_credenciales.txt
#  Errores de la aplicación:   /var/log/nginx/esmeralda_error.log
#
#  Con dominio propio (opcional):  sudo DOMINIO=esmeralda.midominio.com bash instalar_vps.sh
#
#  Olvidó la clave de admin:        sudo bash instalar_vps.sh --reset-admin
#  Base de datos DESDE CERO (¡borra los datos!):
#                                   sudo bash instalar_vps.sh --reinstalar-bd
# =====================================================================
set -euo pipefail

APP_DIR=/var/www/esmeralda
DB_NAME=esmeralda
DB_USER=esmeralda
CRED_FILE=/root/esmeralda_credenciales.txt
BACKUP_DIR=/var/backups/esmeralda
ORIGEN="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REINSTALAR_BD=0
RESET_ADMIN=0
for arg in "$@"; do
    case "$arg" in
        --reinstalar-bd) REINSTALAR_BD=1 ;;
        --reset-admin)   RESET_ADMIN=1 ;;
    esac
done

verde()  { printf '\n\033[1;32m==> %s\033[0m\n' "$*"; }
aviso()  { printf '\033[1;33m[!] %s\033[0m\n' "$*"; }
fallo()  { printf '\033[1;31m[X] %s\033[0m\n' "$*"; exit 1; }
servicio() { systemctl "$1" "$2" 2>/dev/null || service "$2" "$1" >/dev/null 2>&1 || true; }
clave_aleatoria() { openssl rand -base64 64 | tr -dc 'A-Za-z0-9' | cut -c1-"${1:-20}"; }

# ---------- 0. Comprobaciones ----------
[[ $EUID -eq 0 ]] || fallo "Ejecute con sudo:  sudo bash instalar_vps.sh"
grep -qi ubuntu /etc/os-release || aviso "Este script está pensado para Ubuntu; continuando de todas formas."

verde "Buscando los archivos de la aplicación"
TMP_APP=""
if [[ -f "$ORIGEN/esmeralda.zip" ]]; then
    apt-get update -qq && apt-get install -y -qq unzip >/dev/null
    TMP_APP=$(mktemp -d)
    unzip -q "$ORIGEN/esmeralda.zip" -d "$TMP_APP"
    FUENTE="$TMP_APP/esmeralda"
elif [[ -f "$ORIGEN/index.php" && -d "$ORIGEN/includes" ]]; then
    FUENTE="$ORIGEN"                         # el script está dentro de la carpeta del proyecto
elif [[ -d "$ORIGEN/esmeralda" ]]; then
    FUENTE="$ORIGEN/esmeralda"
else
    fallo "No encontré esmeralda.zip ni la carpeta esmeralda junto a este script."
fi
[[ -f "$FUENTE/database/esmeralda.sql" ]] || fallo "Falta database/esmeralda.sql en $FUENTE"
echo "Fuente: $FUENTE"

# ---------- 1. Paquetes ----------
export DEBIAN_FRONTEND=noninteractive

# Si una instalación anterior usó MariaDB, se respaldan los datos y se reemplaza por MySQL
# (no pueden convivir: ambos usan el puerto 3306 y la carpeta /var/lib/mysql).
DUMP_MIGRACION=""
if dpkg-query -W -f='${Status}' mariadb-server 2>/dev/null | grep -q "install ok installed"; then
    verde "Migrando de MariaDB a MySQL (se conservan los datos)"
    mkdir -p "$BACKUP_DIR"; chmod 700 "$BACKUP_DIR"
    servicio start mariadb
    if mysql -N -e "SHOW DATABASES LIKE '$DB_NAME'" 2>/dev/null | grep -qx "$DB_NAME"; then
        DUMP_MIGRACION="$BACKUP_DIR/migracion_mariadb_$(date +%Y%m%d_%H%M%S).sql"
        mysqldump --single-transaction --default-character-set=utf8mb4 --routines "$DB_NAME" > "$DUMP_MIGRACION" \
            || fallo "No se pudo respaldar la base de datos de MariaDB. No se cambió nada."
        sed -i '/^\/\*M!/d' "$DUMP_MIGRACION"      # quita marcas propias de MariaDB que MySQL no entiende
        echo "Respaldo de la migración: $DUMP_MIGRACION"
    fi
    servicio stop mariadb
    for i in $(seq 1 20); do pgrep -x mariadbd >/dev/null || pgrep -x mysqld >/dev/null || break; sleep 1; done
    pkill -x mariadbd 2>/dev/null || true; pkill -x mysqld_safe 2>/dev/null || true; sleep 2
    apt-get purge -y -qq mariadb-server mariadb-client mariadb-common >/dev/null 2>&1 || true
    apt-get purge -y -qq 'mariadb-*' >/dev/null 2>&1 || true
    apt-get autoremove -y -qq >/dev/null 2>&1 || true
    SELLO=$(date +%Y%m%d_%H%M%S)
    [[ -d /var/lib/mysql ]] && mv /var/lib/mysql "/var/lib/mysql.mariadb.$SELLO"
    [[ -d /etc/mysql ]] && mv /etc/mysql "/etc/mysql.mariadb.$SELLO"
    echo "Datos antiguos de MariaDB guardados en /var/lib/mysql.mariadb.$SELLO"
fi

verde "Instalando Nginx, PHP-FPM y MySQL (puede tardar unos minutos)"
apt-get update -qq
# Ojo: NO instalar el paquete "php" a secas; en Ubuntu arrastra libapache2-mod-php y Apache.
apt-get install -y -qq nginx mysql-server php-fpm php-cli php-mysql php-mbstring \
    php-xml php-curl php-zip unzip rsync ufw cron >/dev/null

# Si el servidor tenía Apache (instalación anterior), se apaga para liberar el puerto 80
if command -v apache2 >/dev/null 2>&1 || [[ -d /etc/apache2 ]]; then
    aviso "Se encontró Apache: se detiene y deshabilita para que Nginx use el puerto 80."
    servicio stop apache2; servicio disable apache2
fi

# Versión de PHP-FPM instalada (la más reciente que tenga carpeta fpm)
PHP_VER=""
for v in $(ls /etc/php 2>/dev/null | sort -V); do
    if [[ -d "/etc/php/$v/fpm" ]]; then PHP_VER="$v"; fi
done
[[ -n "$PHP_VER" ]] || fallo "No se encontró PHP-FPM instalado."
echo "PHP-FPM $PHP_VER"
servicio enable mysql; servicio start mysql
for i in $(seq 1 30); do mysqladmin ping >/dev/null 2>&1 && break; sleep 1; done
mysqladmin ping >/dev/null 2>&1 || fallo "MySQL no arrancó (revise: journalctl -u mysql)"
# PHP-FPM (usuario www-data) necesita poder entrar a la carpeta del socket de MySQL
[[ -d /run/mysqld ]] && chmod 755 /run/mysqld
servicio enable "php${PHP_VER}-fpm"
servicio enable nginx

# ---------- 2. Base de datos ----------
verde "Configurando la base de datos"
# Endurecer MySQL: quitar usuarios anónimos y base de pruebas (si existieran)
mysql -e "DROP USER IF EXISTS ''@'localhost'; DROP USER IF EXISTS ''@'$(hostname)'; DROP DATABASE IF EXISTS test; FLUSH PRIVILEGES;"

# Reutilizar la clave si ya se instaló antes
if [[ -f "$CRED_FILE" ]] && grep -q '^DB_PASS=' "$CRED_FILE"; then
    DB_PASS=$(grep '^DB_PASS=' "$CRED_FILE" | cut -d= -f2)
else
    DB_PASS=$(clave_aleatoria 24)
fi
mysql -e "CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
          ALTER USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';"

TABLAS=$(mysql -N -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='$DB_NAME';")
ADMIN_PASS=""
if [[ "$TABLAS" -eq 0 && -n "$DUMP_MIGRACION" && $REINSTALAR_BD -eq 0 ]]; then
    mysql -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    mysql --default-character-set=utf8mb4 "$DB_NAME" < "$DUMP_MIGRACION" || fallo "No se pudo importar el respaldo $DUMP_MIGRACION en MySQL."
    aviso "Datos migrados desde MariaDB: jugadores, usuarios y claves se conservan."
    NUEVO_HASH=0
elif [[ "$TABLAS" -eq 0 || $REINSTALAR_BD -eq 1 ]]; then
    [[ $REINSTALAR_BD -eq 1 && "$TABLAS" -gt 0 ]] && aviso "Reinstalando la base de datos: se borran los datos anteriores."
    mysql --default-character-set=utf8mb4 < "$FUENTE/database/esmeralda.sql"
    NUEVO_HASH=1
else
    aviso "La base de datos ya existe con datos: NO se modifica (use --reinstalar-bd para empezar de cero)."
    NUEVO_HASH=0
fi
mysql -e "GRANT SELECT, INSERT, UPDATE, DELETE ON \`$DB_NAME\`.* TO '$DB_USER'@'localhost'; FLUSH PRIVILEGES;"

# Clave aleatoria para admin (instalación nueva o --reset-admin); se guarda de inmediato
if [[ $NUEVO_HASH -eq 1 || $RESET_ADMIN -eq 1 ]]; then
    ADMIN_PASS=$(clave_aleatoria 12)
    HASH=$(ADMIN_PASS="$ADMIN_PASS" php -r 'echo password_hash(getenv("ADMIN_PASS"), PASSWORD_DEFAULT);')
    mysql "$DB_NAME" -e "UPDATE usuarios SET clave='$HASH', activo=1 WHERE usuario='admin';"
    [[ $(mysql -N "$DB_NAME" -e "SELECT COUNT(*) FROM usuarios WHERE usuario='admin'") -eq 1 ]] \
        || mysql "$DB_NAME" -e "INSERT INTO usuarios (nombre, usuario, clave, rol) VALUES ('Administrador del Sistema','admin','$HASH','administrador');"
    { echo "DB_PASS=$DB_PASS"; echo "APP_USUARIO=admin"; echo "APP_CLAVE_INICIAL=$ADMIN_PASS"; } > "$CRED_FILE"
    chmod 600 "$CRED_FILE"
fi

# ---------- 3. Archivos de la aplicación ----------
verde "Copiando la aplicación a $APP_DIR"
mkdir -p "$APP_DIR"
# Conservar fotos subidas si es una actualización
rsync_disponible=$(command -v rsync || true)
if [[ -n "$rsync_disponible" ]]; then
    rsync -a --delete --exclude 'uploads/fotos/*' --exclude 'config/config.php' --exclude 'config/config.local.php' \
          --exclude 'instalar_vps.sh' --exclude 'README.md' \
          --exclude '.git' --exclude '.gitignore' --exclude '.gitattributes' --exclude 'scripts' --exclude '.vscode' \
          "$FUENTE/" "$APP_DIR/"
else
    ( cd "$FUENTE" && tar --exclude='./uploads/fotos/*' --exclude='./config/config.php' --exclude='./config/config.local.php' --exclude='./instalar_vps.sh' --exclude='./README.md' --exclude='./.git' --exclude='./.gitignore' --exclude='./.gitattributes' --exclude='./scripts' --exclude='./.vscode' -cf - . ) | ( cd "$APP_DIR" && tar -xf - )
fi
mkdir -p "$APP_DIR/uploads/fotos"

# config.php con las credenciales del servidor (sólo se crea/actualiza aquí)
cp "$FUENTE/config/config.php" "$APP_DIR/config/config.php"
sed -i "s/getenv('DB_USER') ?: 'root'/getenv('DB_USER') ?: '$DB_USER'/" "$APP_DIR/config/config.php"
sed -i "s/getenv('DB_PASS') : ''/getenv('DB_PASS') : '$DB_PASS'/" "$APP_DIR/config/config.php"
grep -q "'$DB_PASS'" "$APP_DIR/config/config.php" || fallo "No se pudo escribir la clave en config.php"

# Permisos: el servidor web sólo puede escribir en uploads/
chown -R root:www-data "$APP_DIR"
find "$APP_DIR" -type d -exec chmod 750 {} \;
find "$APP_DIR" -type f -exec chmod 640 {} \;
chown -R www-data:www-data "$APP_DIR/uploads"
chmod 770 "$APP_DIR/uploads" "$APP_DIR/uploads/fotos"

# ---------- 4. Nginx y PHP-FPM ----------
verde "Configurando Nginx"
DOMINIO="${DOMINIO:-_}"     # "_" = responde por la IP del servidor
# Escuchar también por IPv6 sólo si el servidor lo tiene (algunos VPS no)
LISTEN6=""
[[ -f /proc/net/if_inet6 ]] && LISTEN6="listen [::]:80 default_server;"
cat > /etc/nginx/sites-available/esmeralda <<EOF
server {
    listen 80 default_server;
    $LISTEN6
    server_name $DOMINIO;
    root $APP_DIR;
    index index.php;

    client_max_body_size 8M;          # nginx acepta 1 MB por defecto; las fotos pueden pesar 2 MB
    server_tokens off;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header Referrer-Policy "same-origin" always;

    access_log /var/log/nginx/esmeralda_access.log;
    error_log  /var/log/nginx/esmeralda_error.log;

    # Equivalente a los .htaccess (nginx no los lee)
    location ^~ /.well-known/acme-challenge/ { allow all; }       # para un futuro certificado HTTPS
    location ~ /\.                                 { deny all; }  # .git, .htaccess, .gitignore...
    location ~ ^/(config|database|includes)/       { deny all; }
    location ~* ^/uploads/.*\.(php|phtml|phar|pl|py|cgi|sh)\$ { deny all; }
    location ~* \.(sh|sql|md)\$                    { deny all; }

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php${PHP_VER}-fpm.sock;
    }
}
EOF
rm -f /etc/nginx/sites-enabled/default
ln -sf /etc/nginx/sites-available/esmeralda /etc/nginx/sites-enabled/esmeralda

cat > "/etc/php/${PHP_VER}/fpm/conf.d/99-esmeralda.ini" <<'EOF'
expose_php = Off
display_errors = Off
log_errors = On
upload_max_filesize = 4M
post_max_size = 8M
date.timezone = America/Caracas
session.cookie_httponly = 1
session.use_strict_mode = 1
EOF

nginx -t >/dev/null 2>&1 || fallo "Error en la configuración de Nginx (ejecute: nginx -t)"
servicio restart "php${PHP_VER}-fpm"
servicio restart nginx

# ---------- 5. Firewall ----------
verde "Configurando el firewall (SSH y web)"
if command -v ufw >/dev/null; then
    ufw allow OpenSSH >/dev/null 2>&1 || ufw allow 22/tcp >/dev/null 2>&1 || true
    ufw allow 'Nginx HTTP' >/dev/null 2>&1 || ufw allow 80/tcp >/dev/null 2>&1 || true
    ufw --force enable >/dev/null 2>&1 || aviso "No se pudo activar ufw (puede que el proveedor use su propio firewall)."
fi

# ---------- 6. Respaldos diarios ----------
verde "Programando respaldo diario de la base de datos (2:30 a.m., se guardan 14 días)"
mkdir -p "$BACKUP_DIR"; chmod 700 "$BACKUP_DIR"
cat > /etc/cron.d/esmeralda-respaldo <<EOF
30 2 * * * root mysqldump --single-transaction --default-character-set=utf8mb4 $DB_NAME | gzip > $BACKUP_DIR/esmeralda_\$(date +\%Y\%m\%d).sql.gz && tar -czf $BACKUP_DIR/fotos_\$(date +\%Y\%m\%d).tar.gz -C $APP_DIR uploads/fotos && find $BACKUP_DIR -type f -mtime +14 -delete
EOF
servicio enable cron; servicio start cron

# ---------- 7. Credenciales y resumen ----------
IP=$(curl -s --max-time 5 https://api.ipify.org 2>/dev/null || hostname -I | awk '{print $1}')
{
    echo "# Credenciales - Sistema La Esmeralda ($(date '+%d/%m/%Y %H:%M'))"
    echo "URL=http://$IP/"
    echo "DB_NAME=$DB_NAME"
    echo "DB_USER=$DB_USER"
    echo "DB_PASS=$DB_PASS"
    if [[ -n "$ADMIN_PASS" ]]; then
        echo "APP_USUARIO=admin"
        echo "APP_CLAVE_INICIAL=$ADMIN_PASS"
    elif [[ -f "$CRED_FILE" ]]; then
        grep -E '^APP_' "$CRED_FILE" || true
    fi
} > "$CRED_FILE.nuevo"
mv "$CRED_FILE.nuevo" "$CRED_FILE"; chmod 600 "$CRED_FILE"
[[ -n "$TMP_APP" ]] && rm -rf "$TMP_APP"

CODIGO=$(curl -s -o /dev/null -w '%{http_code}' http://localhost/login.php || echo "?")

echo
echo "================================================================"
echo "  INSTALACIÓN TERMINADA   (prueba local: HTTP $CODIGO)"
echo "================================================================"
echo "  Abra en el navegador:   http://$IP/"
if [[ -n "$ADMIN_PASS" ]]; then
echo "  Usuario:                admin"
echo "  Contraseña inicial:     $ADMIN_PASS"
echo "  -> Cámbiela en «Cambiar clave» al entrar."
else
echo "  Usuarios y claves: los mismos de antes (la base de datos no se tocó)."
fi
echo
echo "  Credenciales guardadas en: $CRED_FILE  (sólo root)"
echo "  Respaldos diarios en:      $BACKUP_DIR"
echo "================================================================"
