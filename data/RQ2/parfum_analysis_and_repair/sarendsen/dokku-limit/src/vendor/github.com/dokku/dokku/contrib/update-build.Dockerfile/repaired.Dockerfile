FROM ubuntu:14.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y --no-install-recommends install gcc git build-essential wget ruby-dev ruby1.9.1 lintian rpm help2man man-db && rm -rf /var/lib/apt/lists/*;
RUN command -v fpm > /dev/null || sudo gem install fpm --no-ri --no-rdoc

ARG WORKDIR=/go/src/github.com/dokku/dokku

WORKDIR ${WORKDIR}

COPY . ${WORKDIR}

RUN make deb-dokku-update rpm-dokku-update

RUN mkdir -p /data \
    && cp /tmp/*.deb /data \
    && cp /tmp/*.rpm /data \
    && ls -lha /data/
