FROM postgres:13.2
ENV POSTGRES_USER shadowd
COPY misc/databases/pgsql_layout.sql /docker-entrypoint-initdb.d