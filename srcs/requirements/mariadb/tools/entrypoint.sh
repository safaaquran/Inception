#!/bin/sh
echo "Database name: $MYSQL_DATABASE"
set -e
if [ -d "/var/lib/mysql/mysql" ]; then
	echo "MariaDB is initialized"
else
	echo "Initializing the database"
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi
exec mariadbd
