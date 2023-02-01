FROM ubuntu:xenial

ARG DEBIAN_FRONTEND=noninteractive
ARG MYSQL_APT_CONFIG_DEB=mysql-apt-config_0.8.12-1_all.deb

RUN apt-get update && apt-get install --no-install-recommends -y wget lsb-release && rm -rf /var/lib/apt/lists/*
RUN wget "https://dev.mysql.com/get/$MYSQL_APT_CONFIG_DEB"
RUN dpkg -i $MYSQL_APT_CONFIG_DEB && rm mysql-apt-config_0.8.12-1_all.deb
RUN apt-get update && apt-get install --no-install-recommends -y mysql-server mysql-client && rm -rf /var/lib/apt/lists/*

ARG MYSQL_USER=efes
ARG MYSQL_PASSWORD=123
ARG MYSQL_DATABASE=efes

# Load schema.
ADD docker-init-mysql.sh /tmp/
ADD schema.sql /tmp/
RUN ["bash", "/tmp/docker-init-mysql.sh"]

# Print logs to stderr.
RUN ln -sf /dev/stderr /var/log/mysql/error.log

# Wrapper to catch SIGINT and forward as SIGTERM.
COPY run.sh run.sh
ENTRYPOINT ["/bin/bash", "/run.sh"]

CMD ["mysqld", "--user=root"]

VOLUME /var/lib/mysql
EXPOSE 3306
