FROM alpine:3.12.0

ENV PGDATA "/var/lib/postgresql/data"

RUN apk update --no-cache \
  && apk add --no-cache postgresql postgresql-dev cmake build-base git bash \
  && git clone --branch 1.7.2 https://github.com/timescale/timescaledb.git /tmp/timescaledb \
  && cd /tmp/timescaledb && ./bootstrap -DREGRESS_CHECKS=OFF && cd build && make && make install && cd / \
  && mkdir /run/postgresql \
  && chown postgres:postgres /run/postgresql \
  && apk del postgresql-dev cmake build-base git bash \
  && rm -rf /tmp/timescaledb \
  && rm -rf /var/cache/apk/*

# Copying the db schema and run script
COPY init_db.sql /docker-entrypoint-initdb.d/
COPY psql_setup /usr/sbin/psql_setup

USER postgres
RUN mkdir "${PGDATA}" \
  && chmod 0700 "${PGDATA}" \
  && initdb "${PGDATA}" \
  && echo "shared_preload_libraries = 'timescaledb'" >> "${PGDATA}/postgresql.conf" \
  && echo "log_destination = 'csvlog'" >> "${PGDATA}/postgresql.conf" \
  && echo "logging_collector = on" >> "${PGDATA}/postgresql.conf" \
  && echo "log_directory = '/var/log/postgresql'" >> "${PGDATA}/postgresql.conf" \
  && echo "log_filename = '%Y-%m-%d_%H%M%S.log'" >> "${PGDATA}/postgresql.conf" \
  && echo "listen_addresses = '*'" >> "${PGDATA}/postgresql.conf" \
  && echo "host all  all    0.0.0.0/0  trust" >> "${PGDATA}/pg_hba.conf"

# Running the post-container script
USER root
RUN /usr/sbin/psql_setup

USER postgres
CMD ["postgres"]
