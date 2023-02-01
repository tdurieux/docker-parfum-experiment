FROM ubuntu:18.04
RUN apt-get update
RUN apt-get install -y mariadb-client

COPY ./docker-tools/ /docker-tools
COPY ./install/install.sql /docker-tools/install.sql

RUN chmod +x /docker-tools/wait-for-it.sh
RUN chmod +x /docker-tools/init-db.sh
