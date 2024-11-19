#!/bin/sh
sleep 3
until mysql --host=mariadb --user=$DATABASE_USER_NAME --password=$DATABASE_USER_PASSWORD -e '\c'; do
    sleep 3
done

if ! wp-cli core is-installed --path=/var/www/html --allow-root; then
    wp-cli core download --allow-root
    wp-cli config create --allow-root \
        --dbname=$DATABASE_NAME --dbuser=$DATABASE_USER_NAME --dbpass=$DATABASE_USER_PASSWORD --dbhost=mariadb
    wp-cli core install --allow-root --url=$DOMAIN_NAME --title=$WP_TITLE --admin_user=$WP_ADMIN_NAME --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL
    wp-cli user create --allow-root --porcelain \
    "$WP_USER_NAME" "$WP_USER_EMAIL" --role=author --user_pass="$WP_USER_PASSWORD"
fi
chown -R www-data:www-data /var/www

exec "$@"