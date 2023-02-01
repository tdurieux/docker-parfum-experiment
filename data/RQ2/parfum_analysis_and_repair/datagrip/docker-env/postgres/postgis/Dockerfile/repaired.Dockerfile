FROM postgres:9.6

COPY init.sh /docker-entrypoint-initdb.d/init.sh

RUN apt-get update && \
    apt-get install --no-install-recommends -y cmake pgxnclient postgresql-plpython-9.6 postgresql-server-dev-9.6 g++ m4 && \
    apt-get install --no-install-recommends -y postgis postgresql-9.6-postgis-scripts && rm -rf /var/lib/apt/lists/*;

RUN pgxn install madlib=1.11