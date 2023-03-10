ARG POSTGRES_VERSION=14
ARG POSTGIS_VERSION=3

FROM postgres:${POSTGRES_VERSION}

ARG POSTGRES_VERSION
ARG POSTGIS_VERSION

# the temporal tables extension hasn't released a new version in a long time
# (although there are some commits on master), so we pin the version to a specific commit hash
ARG TEMPORAL_TABLE_COMMIT_HASH=3ce22da51f2549e8f8b8fbf2850c63eb3a2f1fbb


ENV MONKEY_DB_PASSWORD=

RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates build-essential postgresql-${POSTGRES_VERSION}-postgis-${POSTGIS_VERSION} postgresql-${POSTGRES_VERSION}-postgis-${POSTGIS_VERSION}-scripts postgresql-contrib-${POSTGRES_VERSION} postgresql-server-dev-${POSTGRES_VERSION} git && rm -rf /var/lib/apt/lists/*;

RUN cd /tmp && git clone https://github.com/arkhipov/temporal_tables \
    && cd /tmp/temporal_tables \
    && git checkout ${TEMPORAL_TABLE_COMMIT_HASH} \
	&& make \
    && make install \
    && rm -rf /tmp/temporal_tables


RUN mkdir -p /docker-entrypoint-initdb.d/
COPY env/docker/postgres_init.sh /docker-entrypoint-initdb.d/postgres_init.sh
COPY env/postgres/schema.sql /tmp/imagemonkeydb/schema.sql
COPY env/postgres/defaults.sql /tmp/imagemonkeydb/defaults.sql
COPY env/postgres/indexes.sql /tmp/imagemonkeydb/indexes.sql
COPY env/postgres/stored_procs /tmp/imagemonkeydb/postgres_stored_procs
COPY env/postgres/functions /tmp/imagemonkeydb/postgres_functions

RUN chown -R postgres:postgres /tmp/imagemonkeydb \
    && chmod -R u+rx /tmp/imagemonkeydb
