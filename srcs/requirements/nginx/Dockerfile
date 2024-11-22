# Use Debian Buster as the base image
FROM debian:buster

# Update and install required packages
RUN apt-get update -y && apt-get install -y \
    nginx \
    openssl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create directories for SSL certificates
RUN mkdir -p /etc/ssl/private /etc/ssl/certs

# Generate a self-signed SSL certificate
RUN openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt \
    -subj "/C=DE/ST=/L=Heilbronn/O=42/OU=Student/CN=ahocuk.42.fr"

# Remove default Nginx site configuration
RUN rm -f /etc/nginx/sites-available/default

# Copy the custom Nginx configuration file
COPY default /etc/nginx/sites-available/default

# Set permissions for the web root
RUN chmod -R 777 /var/www/html

# Expose port 443 for HTTPS
EXPOSE 443

# Run Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
