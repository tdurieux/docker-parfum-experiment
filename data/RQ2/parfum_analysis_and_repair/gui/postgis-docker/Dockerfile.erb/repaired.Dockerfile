FROM postgres:<%= postgres_tag %>

ENV POSTGIS_MAJOR=<%= postgis_major %> \
  POSTGIS_VERSION=<%= postgis_version %>

RUN apt-get update && \
  apt-cache showpkg postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR && \
  apt-get install -y --no-install-recommends \
    postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR=$POSTGIS_VERSION \
    postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR-scripts=$POSTGIS_VERSION \
    postgis && \
  rm -rf /var/lib/apt/lists/*

LABEL org.opencontainers.image.source="https://github.com/GUI/postgis-docker" \
  org.opencontainers.image.licenses="MIT"