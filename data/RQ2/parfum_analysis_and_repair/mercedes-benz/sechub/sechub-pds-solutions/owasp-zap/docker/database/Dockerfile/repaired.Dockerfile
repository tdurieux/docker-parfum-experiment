# SPDX-License-Identifier: MIT

FROM alpine:3.15

ARG DATABASE_FOLDER=/database
ENV PGDATA="$DATABASE_FOLDER/data"

# install PostgreSQL
RUN apk update --no-cache && \
    apk add --no-cache postgresql

# setup PostgreSQL directories
RUN mkdir --parents "$PGDATA" && \
    mkdir --parents "/run/postgresql" && \
    chown --recursive postgres:postgres "$DATABASE_FOLDER" "/run/postgresql"

# initialize PostgreSQL
RUN su -c "pg_ctl init" postgres

# PostgreSQL configuration files
RUN rm "$PGDATA/pg_hba.conf"
COPY pg_hba.conf  "$PGDATA/pg_hba.conf"

RUN rm "$PGDATA/postgresql.conf"
COPY postgresql.conf "$PGDATA/postgresql.conf"

RUN chown postgres:postgres "$PGDATA/pg_hba.conf" "$PGDATA/postgresql.conf"

# copy run script into container