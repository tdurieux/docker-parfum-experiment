ARG POSTGRES_VERSION
FROM postgres:${POSTGRES_VERSION}

RUN echo 'CREATE EXTENSION IF NOT EXISTS "postgis";' > /docker-entrypoint-initdb.d/postgis.sql

ARG POSTGIS_VERSION
ARG POSTGRES_VERSION
RUN apt-get update \
    && apt-get install --no-install-recommends -y postgresql-${POSTGRES_VERSION}-postgis-${POSTGIS_VERSION} && rm -rf /var/lib/apt/lists/*;
