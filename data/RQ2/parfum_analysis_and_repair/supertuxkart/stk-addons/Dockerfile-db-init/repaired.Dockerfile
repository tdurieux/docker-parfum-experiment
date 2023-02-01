FROM ubuntu:18.04
RUN apt-get update && apt-get install --no-install-recommends -y mariadb-client && rm -rf /var/lib/apt/lists/*;

COPY ./docker-tools/ /docker-tools
COPY ./install/install.sql /docker-tools/install.sql

RUN chmod +x /docker-tools/wait-for-it.sh
RUN chmod +x /docker-tools/init-db.sh
