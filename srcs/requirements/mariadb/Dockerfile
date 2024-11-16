FROM debian:buster

RUN apt-get update
RUN apt-get install mariadb-server -y

COPY mariadb-config.cnf /etc/mysql/my.cnf

COPY entrypoint.sh ./

ENTRYPOINT [ "./entrypoint.sh" ]
CMD [ "mysqld" ]