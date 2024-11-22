# Use Debian Buster as the base image
FROM debian:buster

# Update package lists and install necessary packages
RUN apt-get update -y && apt-get install -y \
    curl \
    php php-common php-mysqli php-fpm \
    mariadb-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create necessary directories
RUN mkdir -p /run/php /var/www/html

# Set the working directory
WORKDIR /var/www/html

# Download and install WP-CLI
RUN curl -sSL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/local/bin/wp-cli \
    && chmod +x /usr/local/bin/wp-cli

# Copy the entrypoint script and PHP-FPM configuration
COPY entrypoint.sh /entrypoint.sh
COPY www.conf /etc/php/7.3/fpm/pool.d/www.conf

# Ensure the entrypoint script is executable
RUN chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Default command to run PHP-FPM in non-daemon mode
CMD ["php-fpm7.3", "--nodaemonize"]
