FROM postgres:10.5

COPY postgres-init /docker-entrypoint-initdb.d
RUN chmod 755 /docker-entrypoint-initdb.d/01-postgres-config.sh
RUN chmod 755 /docker-entrypoint-initdb.d/02-init.sh