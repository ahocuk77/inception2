FROM debian:buster

RUN apt-get -y update
RUN apt-get -y install curl
RUN apt-get -y install php php-common php-mysqli php-fpm
RUN apt-get -y install mariadb-client

RUN mkdir -p /run/php
RUN mkdir -p /var/www/html/
WORKDIR /var/www/html

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp-cli

COPY entrypoint.sh /entrypoint.sh
COPY www.conf /etc/php/7.3/fpm/pool.d/

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "php-fpm7.3", "--nodaemonize" ]