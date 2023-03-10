FROM postgres:12.2
RUN apt-get update && apt-get install --no-install-recommends -y wget && \
    mkdir -p /docker-entrypoint-initdb.d && \
    wget https://storage.googleapis.com/continuous-intelligence/store47-2016.csv -O /docker-entrypoint-initdb.d/store47-2016.csv && rm -rf /var/lib/apt/lists/*;

COPY initialize.sql /docker-entrypoint-initdb.d/initialize.sql
