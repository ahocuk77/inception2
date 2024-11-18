FROM debian:buster

RUN apt-get -y update
RUN apt-get -y install nginx
RUN apt-get -y install openssl
RUN mkdir -p /etc/ssl/private
RUN mkdir -p /etc/ssl/certs
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt -subj "/C=DE/ST=/L=Heilbronn/O=42/OU=Student/CN=ahocuk.42.fr"
RUN rm /etc/nginx/sites-available/default

COPY default /etc/nginx/sites-available/

EXPOSE 443
RUN chmod -R 777 /var/www/html
CMD [ "nginx", "-g", "daemon off;" ]