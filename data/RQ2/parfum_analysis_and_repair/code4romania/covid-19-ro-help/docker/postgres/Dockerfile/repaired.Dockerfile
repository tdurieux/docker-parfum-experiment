FROM postgres:12

RUN apt update -y && apt install --no-install-recommends -y postgresql-contrib && rm -rf /var/lib/apt/lists/*;
COPY ./docker/postgres/docker-entrypoint-initdb.d /
