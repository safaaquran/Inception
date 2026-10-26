#!/bin/sh
set -e

MYSQL_PASSWORD=$(cat /run/secrets/db_password)
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
MYSQL_ADMIN_PASSWORD=$(cat /run/secrets/db_admin_password)

DATADIR="/var/lib/mysql"
SOCKET="/run/mysqld/mysqld.sock"
PIDFILE="/run/mysqld/mysqld.pid"

: "${MYSQL_DATABASE:?MYSQL_DATABASE is required}"
: "${MYSQL_USER:?MYSQL_USER is required}"
: "${MYSQL_PASSWORD:?MYSQL_PASSWORD is required}"
: "${MYSQL_ROOT_PASSWORD:?MYSQL_ROOT_PASSWORD is required}"
: "${MYSQL_ADMIN_USER:?MYSQL_ADMIN_USER is required}"
: "${MYSQL_ADMIN_PASSWORD:?MYSQL_ADMIN_PASSWORD is required}"

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

if [ ! -d "$DATADIR/mysql" ]; then
    echo "Initializing MariaDB system tables..."
    mariadb-install-db --user=mysql --datadir="$DATADIR"
fi

if [ ! -f "$DATADIR/.inception_initialized" ]; then
    echo "Starting temporary MariaDB server..."

    mariadbd \
        --user=mysql \
        --datadir="$DATADIR" \
        --socket="$SOCKET" \
        --pid-file="$PIDFILE" \
        --skip-networking &

    TEMP_PID=$!

    cleanup() {
        mariadb-admin --socket="$SOCKET" -uroot shutdown 2>/dev/null || true
        wait "$TEMP_PID" 2>/dev/null || true
    }

    trap cleanup EXIT

    until mariadb-admin --socket="$SOCKET" -uroot ping >/dev/null 2>&1; do
        if ! kill -0 "$TEMP_PID" 2>/dev/null; then
            echo "Temporary MariaDB server failed to start."
            exit 1
        fi
        sleep 1
    done

    echo "Creating database and users..."

    mariadb --socket="$SOCKET" -uroot <<SQL
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%'
IDENTIFIED BY '${MYSQL_PASSWORD}';

GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.*
TO '${MYSQL_USER}'@'%';

CREATE USER IF NOT EXISTS '${MYSQL_ADMIN_USER}'@'%'
IDENTIFIED BY '${MYSQL_ADMIN_PASSWORD}';

GRANT ALL PRIVILEGES ON *.*
TO '${MYSQL_ADMIN_USER}'@'%'
WITH GRANT OPTION;

FLUSH PRIVILEGES;
SQL

    mariadb-admin --socket="$SOCKET" \
        -uroot -p"$MYSQL_ROOT_PASSWORD" shutdown

    wait "$TEMP_PID" || true
    trap - EXIT

    touch "$DATADIR/.inception_initialized"
    echo "Database initialization complete."
fi

echo "Starting MariaDB server..."
exec mariadbd --user=mysql --datadir="$DATADIR"

