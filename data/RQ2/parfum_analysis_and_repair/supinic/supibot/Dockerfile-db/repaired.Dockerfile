FROM mariadb:latest

COPY db-init.sql /docker-entrypoint-initdb.d/db-init.sql