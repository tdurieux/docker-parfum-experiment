FROM postgres:14

RUN apt update -y && apt install -y --no-install-recommends postgresql-contrib && rm -rf /var/lib/apt/lists/*;
COPY ./docker-entrypoint-initdb.d /
