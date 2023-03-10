# temporary: need the latest GDAL for PostgreSQL 12 compat
FROM debian:unstable
MAINTAINER https://github.com/ealgis/ealgis

# httpredir is often down, just use the AARNET mirror
RUN sed -i s/httpredir.debian.org/mirror.aarnet.edu.au/ /etc/apt/sources.list

# this is a bit of a kitchen sink. we use this container to
# run the various dataset generation scripts
# postgis is only needed for the shp2pgsql binary
RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential \
      python3 python3-dev python3-pip python3-setuptools \
      git gnupg \
      python-cairo liblzma-dev libxml2-dev \
      python3-gdal gdal-bin postgis libxslt-dev pkg-config p7zip unzip \
      libpq-dev \
      wget less git zip && \
  apt-get autoremove -y --purge && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# this is required to get PostgreSQL 9.6 client tools into the container on Jessie
# https://wiki.postgresql.org/wiki/Apt
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update && apt-get install --no-install-recommends -y postgresql-client-12 && \
  apt-get autoremove -y --purge && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN ln -s /usr/bin/python3 /usr/bin/python

WORKDIR /app

RUN pip3 install --no-cache-dir -U "pip<8"

ADD . /ealgis/

RUN pip3 install --no-cache-dir -r /ealgis/requirements-ingest.txt && \
  rm -rf /root/.cache/pip/

RUN pip install --no-cache-dir -e /ealgis/ && rm -rf /root/.cache/pip/
