FROM postgres:alpine
EXPOSE 5432

COPY ./install_extensions.sql /docker-entrypoint-initdb.d/