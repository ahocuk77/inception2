#!/bin/sh

service mysql start
if [ ! -d /var/lib/mysql/$DATABASE_NAME ]; then
    sleep 1
    mysql -e "\
        CREATE DATABASE IF NOT EXISTS ${DATABASE_NAME}; \
        CREATE USER '${DATABASE_USER_NAME}'@'%' IDENTIFIED BY '${DATABASE_USER_PASSWORD}'; \
        GRANT ALL ON ${DATABASE_NAME}.* TO '${DATABASE_USER_NAME}'@'%'; \
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${DATABASE_ROOT_PASSWORD}'; \
        FLUSH PRIVILEGES; "
fi
mysqladmin --user=root --password=$DATABASE_ROOT_PASSWORD shutdown

exec "$@"
