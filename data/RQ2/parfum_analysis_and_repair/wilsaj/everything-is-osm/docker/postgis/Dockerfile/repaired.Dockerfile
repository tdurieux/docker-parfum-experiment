FROM postgres:9.3

RUN apt-get update \
    && apt-get install --no-install-recommends -y postgis && rm -rf /var/lib/apt/lists/*;

COPY init-database.sh /docker-entrypoint-initdb.d/init-database.sh
