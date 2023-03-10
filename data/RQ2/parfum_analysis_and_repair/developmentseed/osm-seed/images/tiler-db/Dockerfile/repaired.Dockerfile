FROM mdillon/postgis:9.5
RUN apt-get update && apt-get install --no-install-recommends -y git ca-certificates && rm -rf /var/lib/apt/lists/*;

COPY ./config/docker-entrypoint.sh /usr/local/bin/
RUN mkdir -p /docker-entrypoint-initdb.d
COPY ./config/initdb_db.sh /docker-entrypoint-initdb.d/postgis.sh
COPY ./config/update_db.sh /usr/local/bin
COPY ./config/update_postgresql.sh /docker-entrypoint-initdb.d

