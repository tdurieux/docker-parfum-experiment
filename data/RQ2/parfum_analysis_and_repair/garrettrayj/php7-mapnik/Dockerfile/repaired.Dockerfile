FROM ubuntu:xenial

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y --no-install-recommends install \
    build-essential \
    libmapnik-dev \
    mapnik-utils \
    php-dev \
    php-gd \
    python-software-properties \
    valgrind && rm -rf /var/lib/apt/lists/*;

RUN mkdir /opt/php7-mapnik
WORKDIR /opt/php7-mapnik
