FROM postgres:13.4-alpine
ENV POSTGRES_PASSWORD postgres
COPY .docker/docker-entrypoint-initdb.d/init.* /docker-entrypoint-initdb.d/