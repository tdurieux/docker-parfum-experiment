FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y postgresql-client && rm -rf /var/lib/apt/lists/*;
COPY wait-for-postgres.sh /bin/wait-for-postgres

ENTRYPOINT ["wait-for-postgres"]