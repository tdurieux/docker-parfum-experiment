FROM mysql:5.7.31

COPY schema.sql /docker-entrypoint-initdb.d/000-schema.sql