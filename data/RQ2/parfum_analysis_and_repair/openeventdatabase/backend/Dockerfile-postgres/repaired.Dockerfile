FROM postgres:9.5
RUN apt-get update && apt-get install --no-install-recommends -y postgis postgresql-9.5-postgis-scripts && rm -rf /var/lib/apt/lists/*;
ADD /setup.sql /docker-entrypoint-initdb.d/
