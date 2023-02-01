FROM mysql:8.0
RUN apt-get update -qq && apt-get install --no-install-recommends -y -qq && rm -rf /var/lib/apt/lists/*;
COPY /mysql/cryptopump.sql /docker-entrypoint-initdb.d/init.sql