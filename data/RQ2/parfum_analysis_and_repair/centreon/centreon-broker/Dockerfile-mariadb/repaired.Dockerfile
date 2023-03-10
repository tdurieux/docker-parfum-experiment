FROM mariadb:latest as builder

# That file does the DB initialization but also runs mysql daemon, by removing the last line it will only init
RUN ["sed", "-i", "s/exec \"$@\"/echo \"not running $@\"/", "/usr/local/bin/docker-entrypoint.sh"]

# needed for initialization
ENV MYSQL_ROOT_PASSWORD=root

MAINTAINER Centreon "support@centreon.com"

WORKDIR /usr/sql
COPY simu/docker/centreon_storage.sql /docker-entrypoint-initdb.d/

# Need to change the datadir to something else that /var/lib/mysql because the parent docker file defines it as a volume.
# httpd://docs.docker.com/engine/reference/builder/#volume :
RUN ["/usr/local/bin/docker-entrypoint.sh", "mysqld", "--datadir", "/initialized-db", "--aria-log-dir-path", "/initialized-db"]

FROM mariadb:latest

COPY --from=builder /initialized-db /var/lib/mysql