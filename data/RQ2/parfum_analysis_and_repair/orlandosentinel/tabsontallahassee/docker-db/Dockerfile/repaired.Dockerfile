FROM postgres:9.4

RUN apt-get update && apt-get install --no-install-recommends postgis -y && rm -rf /var/lib/apt/lists/*;
COPY 001-createdb.sh /docker-entrypoint-initdb.d/
COPY dump.sql.gz /
