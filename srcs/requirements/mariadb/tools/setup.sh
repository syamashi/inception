#!/bin/sh

if [ ! -d "/run/mysql" ]; then
	"[i] /run/mysqld creating..."
	mkdir -p /run/mysqld
fi
chown -R mysql:mysql /run/mysqld

if [ ! -d /var/lib/mysql/mysql ]; then
	echo "[i] initial database creating..."
	chown -R mysql:mysql /var/lib/mysql
	chown -R mysql /var/lib/mysql
	mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql --rpm > /dev/null

  tfile=""
  while [ ! -f "$tfile" ]; do
    tfile=$(mktemp)
  done
	cat << EOF > $tfile
USE mysql ;
FLUSH PRIVILEGES ;
DROP DATABASE IF EXISTS test ;
GRANT ALL ON *.* TO 'root'@'%' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;
GRANT ALL ON *.* TO 'root'@'localhost' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;
SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${MYSQL_ROOT_PASSWORD}') ;
SET PASSWORD FOR 'root'@'%'=PASSWORD('${MYSQL_ROOT_PASSWORD}') ;
FLUSH PRIVILEGES ;
CREATE DATABASE IF NOT EXISTS $WP_DB_NAME CHARACTER SET utf8 COLLATE utf8_general_ci ;
CREATE USER '$WP_DB_USER'@'localhost' IDENTIFIED BY '$WP_DB_PASSWORD';
CREATE USER '$WP_DB_USER'@'%' IDENTIFIED BY '$WP_DB_PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO '$WP_DB_USER'@'localhost';
GRANT ALL PRIVILEGES ON *.* TO '$WP_DB_USER'@'%';
FLUSH PRIVILEGES ;
EOF
# 1. rootは全部のDBの権限
# 2. WP_DB_NAMEというDBにアクセスできるWP_DB_USERというユーザーを作成。

	/usr/bin/mysqld --user=mysql --bootstrap < $tfile
  rm -f $tfile
fi

echo "[i] => Done mysql setting!"

exec "$@"