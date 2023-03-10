FROM postgres:13-bullseye

RUN apt-get update \
    && apt-get install -y --no-install-recommends postgresql-13-wal2json \
    && rm -rf /var/lib/apt/lists/*