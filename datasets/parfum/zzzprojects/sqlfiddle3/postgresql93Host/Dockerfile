FROM postgres:9.3

ENV POSTGRES_PASSWORD password
ENV POSTGRES_DB postgres

COPY ready.sh /

COPY initdb.d /docker-entrypoint-initdb.d
