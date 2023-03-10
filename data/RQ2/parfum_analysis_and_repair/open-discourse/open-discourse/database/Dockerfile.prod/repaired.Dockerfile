FROM postgres:12

COPY data /var/lib/postgresql/data

RUN apt-get update && apt-get install -y --no-install-recommends postgresql-12-rum vim && rm -rf /var/lib/apt/lists/*;
