FROM postgres:9.6.24

ENV POSTGRES_USER=root
ENV POSTGRES_PASSWORD=otel
ENV POSTGRES_DB=otel

COPY init.sql /docker-entrypoint-initdb.d/