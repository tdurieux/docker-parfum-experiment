FROM mysql:5.6
COPY ctldb-example.sql /docker-entrypoint-initdb.d/