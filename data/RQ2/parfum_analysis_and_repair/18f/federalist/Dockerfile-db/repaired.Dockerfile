FROM postgres:11.5

COPY scripts/docker-db-setup.sh /docker-entrypoint-initdb.d/10-docker-db-setup.sh