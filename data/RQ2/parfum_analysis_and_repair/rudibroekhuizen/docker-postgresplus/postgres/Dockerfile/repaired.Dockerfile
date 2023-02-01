# kartoza/postgis
FROM postgres:11

RUN apt-get update && \
 apt-get install --no-install-recommends -y sudo vim curl wget unzip net-tools iputils-ping parallel jq && rm -rf /var/lib/apt/lists/*;

EXPOSE 5432
