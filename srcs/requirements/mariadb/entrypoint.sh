#!/bin/sh

# Start MySQL service
echo "Starting MySQL service..."
service mysql start

# Check if the database already exists
if [ ! -d "/var/lib/mysql/$DATABASE_NAME" ]; then
    echo "Database '$DATABASE_NAME' does not exist. Initializing setup..."
    sleep 1

    # Run MySQL commands to create the database, user, and set privileges
    mysql -e "\
        CREATE DATABASE IF NOT EXISTS \`${DATABASE_NAME}\`; \
        CREATE USER IF NOT EXISTS '${DATABASE_USER_NAME}'@'%' IDENTIFIED BY '${DATABASE_USER_PASSWORD}'; \
        GRANT ALL PRIVILEGES ON \`${DATABASE_NAME}\`.* TO '${DATABASE_USER_NAME}'@'%'; \
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${DATABASE_ROOT_PASSWORD}'; \
        FLUSH PRIVILEGES;"
    echo "Database and user setup completed."
else
    echo "Database '$DATABASE_NAME' already exists. Skipping initialization."
fi

# Shut down MySQL service
echo "Shutting down MySQL service..."
mysqladmin --user=root --password="$DATABASE_ROOT_PASSWORD" shutdown

# Execute the provided command
echo "Executing command: $@"
exec "$@"
