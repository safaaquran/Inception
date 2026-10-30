#!/bin/sh
set -e

WORKDIR="/var/www/html"
DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
export DB_PASSWORD WP_ADMIN_PASSWORD
MAX_RETRIES=30
COUNT=0
until mariadb-admin ping -h mariadb --silent; do
	COUNT=$((COUNT+1))
	if [ "$COUNT" -ge "$MAX_RETRIES" ]; then
		echo "Maria DB is unreachable"
		exit 1
	fi
	sleep 1
done
echo "Maria DB is ready!"

if [ ! -f "$WORKDIR/wp-config.php" ]; then
	wp config create \
		--dbname="$MYSQL_DATABASE" \
		--dbuser="$MYSQL_USER" \
		--dbpass="$DB_PASSWORD" \
		--dbhost="mariadb:3306" \
		--path="$WORKDIR" \
		--allow-root
fi

if ! wp core is-installed --path="$WORKDIR" --allow-root; then
	wp core install \
		--url="https://sal-qur.42.fr" \
		--title="$WP_TITLE" \
		--admin_user="$WP_ADMIN_USER" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="$WP_ADMIN_EMAIL" \
		--path="$WORKDIR" \
		--allow-root
fi

exec php-fpm8.2 -F
