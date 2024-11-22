#!/bin/sh

# Configurable sleep interval
SLEEP_INTERVAL=3

# Wait for the database to become available
echo "Waiting for MariaDB to be ready..."
until mysql --host=mariadb --user="$DATABASE_USER_NAME" --password="$DATABASE_USER_PASSWORD" -e 'SELECT 1;' > /dev/null 2>&1; do
    echo "MariaDB is not ready. Retrying in $SLEEP_INTERVAL seconds..."
    sleep "$SLEEP_INTERVAL"
done
echo "MariaDB is ready!"

# Check if WordPress is already installed
if ! wp-cli core is-installed --path=/var/www/html --allow-root; then
    echo "WordPress is not installed. Proceeding with setup..."

    # Download WordPress core files
    wp-cli core download --allow-root
    echo "WordPress core files downloaded."

    # Create wp-config.php
    wp-cli config create --allow-root \
        --dbname="$DATABASE_NAME" \
        --dbuser="$DATABASE_USER_NAME" \
        --dbpass="$DATABASE_USER_PASSWORD" \
        --dbhost=mariadb
    echo "WordPress configuration file created."

    # Install WordPress
    wp-cli core install --allow-root \
        --url="$DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_NAME" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL"
    echo "WordPress core installed successfully."

    # Create an additional user
    wp-cli user create --allow-root --porcelain \
        "$WP_USER_NAME" "$WP_USER_EMAIL" --role=author --user_pass="$WP_USER_PASSWORD"
    echo "Additional user '$WP_USER_NAME' created with role 'author'."
else
    echo "WordPress is already installed. Skipping setup."
fi

# Set proper ownership for WordPress files
echo "Setting ownership for /var/www..."
chown -R www-data:www-data /var/www
echo "Ownership set successfully."

# Execute the passed command
exec "$@"
