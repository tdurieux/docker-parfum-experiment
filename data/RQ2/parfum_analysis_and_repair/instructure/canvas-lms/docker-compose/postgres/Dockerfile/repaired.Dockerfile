ARG POSTGRES=12
ARG POSTGIS=2.5
ARG POSTGISIMAGE=postgis/postgis

FROM $POSTGISIMAGE:$POSTGRES-$POSTGIS

RUN echo "max_locks_per_transaction = 640" >> /usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample \
 && echo "max_stack_depth = 5MB" >> /usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample \
 && echo "random_page_cost = 1.0" >> /usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample \
 && echo "shared_buffers = 256MB" >> /usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample \
 && echo "effective_cache_size = 256MB" >> /usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample

COPY /create-dbs.sh /docker-entrypoint-initdb.d/
COPY /wait-for-it /

ENV PG_COLLKEY_VERSION 0.5.1

RUN apt-get update --quiet=2 \
  && apt-get install -y --no-install-recommends --quiet=2 \
    build-essential \
    ca-certificates \
    libicu-dev \
    postgresql-server-dev-$PG_MAJOR \
    pgxnclient \
    unzip \
  && pgxnclient download --yes --target ~ pg_collkey=${PG_COLLKEY_VERSION} \
  && unzip ~/pg_collkey-${PG_COLLKEY_VERSION}.zip -d ~/ \
  && cd ~/pg_collkey-${PG_COLLKEY_VERSION} \
  && mv Makefile Makefile.orig \
  && sed '/^DATA = \$(wildcard/d' Makefile.orig > Makefile \
  && make \
  && make install \
  && cp -v ~/pg_collkey-${PG_COLLKEY_VERSION}/pg_collkey--${PG_COLLKEY_VERSION}.sql /usr/share/postgresql/$PG_MAJOR/extension/ \
  && apt-get remove -qqy \
    build-essential \
    ca-certificates \
    libicu-dev \
    postgresql-server-dev-$PG_MAJOR \
    pgxnclient \
    unzip \
  && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*
