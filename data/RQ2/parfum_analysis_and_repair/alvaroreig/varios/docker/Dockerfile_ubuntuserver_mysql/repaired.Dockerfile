# VERSION 0.01
FROM ubuntu:14.04
MAINTAINER Alvaro Reig
VOLUME /data /var/log/
RUN apt-get update -y && apt-get dist-upgrade -y
RUN mkdir /var/log/mysql
RUN apt-get install --no-install-recommends -y mysql-server && rm -rf /var/lib/apt/lists/*;

ENV MYSQL_LOG_DIR /var/log/mysql/

EXPOSE 3306

CMD ["/usr/bin/mysqld_safe"]
