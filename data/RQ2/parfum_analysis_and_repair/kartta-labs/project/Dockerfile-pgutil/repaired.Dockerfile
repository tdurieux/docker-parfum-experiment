FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get install --no-install-recommends -y postgresql-client osm2pgsql gdal-bin unzip wget emacs curl iputils-ping gettext-base osmosis && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["tail", "-f", "/dev/null"]
