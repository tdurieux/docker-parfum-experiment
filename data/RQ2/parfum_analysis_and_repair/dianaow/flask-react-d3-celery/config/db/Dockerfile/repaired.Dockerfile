FROM postgres:9.6

COPY ./docker-entrypoint-initdb.d ./docker-entrypoint-initdb.d
COPY ./init.psql ./init.psql