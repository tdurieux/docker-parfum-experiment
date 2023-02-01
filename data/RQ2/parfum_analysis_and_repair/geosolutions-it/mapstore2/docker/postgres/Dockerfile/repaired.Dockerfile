FROM postgis/postgis:12-3.1
WORKDIR /code
COPY ./01-init-user.sh /docker-entrypoint-initdb.d/
RUN apt-get update \
    && apt-get install --no-install-recommends wget -y \
    && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/*;
RUN wget https://raw.githubusercontent.com/geosolutions-it/geostore/master/doc/sql/002_create_schema_postgres.sql
