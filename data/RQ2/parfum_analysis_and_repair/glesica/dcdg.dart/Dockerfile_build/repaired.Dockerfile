FROM google/dart:2.14 AS build
RUN apt-get -q update && \
    apt-get -y --no-install-recommends install make && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /code
VOLUME /code
WORKDIR /code
