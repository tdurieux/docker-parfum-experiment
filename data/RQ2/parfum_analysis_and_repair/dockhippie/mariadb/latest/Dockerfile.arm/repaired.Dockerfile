FROM webhippie/alpine:latest-arm@sha256:d1ff8861e56a77398bf5b5b04dceee5eec438966a79ecc7cb2c0079156e9b72f

VOLUME ["/var/lib/mysql", "/var/lib/backup", "/etc/mysql/conf.d", "/etc/mysql/init.d"]
EXPOSE 3306

WORKDIR /var/lib/mysql
CMD ["/usr/bin/container"]

RUN apk update && \
  apk upgrade && \
  mkdir -p /var/lib/mysql && \
  groupadd -g 1000 mysql && \
  useradd -u 1000 -d /var/lib/mysql -g mysql mysql -s /bin/bash -m && \
  apk add --no-cache mariadb mariadb-client mariadb-server-utils tzdata && \
  rm -rf /var/cache/apk/* /etc/mysql/* /etc/my.cnf* /var/lib/mysql/*

COPY ./overlay /
