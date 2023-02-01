FROM postgres:12.10

ADD extensions /extensions

RUN apt-get update && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

RUN cd /extensions/postgres-json-schema && make install && make installcheck

COPY extensions/install.sql /docker-entrypoint-initdb.d/
