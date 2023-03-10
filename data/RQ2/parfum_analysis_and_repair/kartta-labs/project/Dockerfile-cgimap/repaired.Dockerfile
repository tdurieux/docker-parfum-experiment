# docker build -t cgimap:latest -f Dockerfile-cgimap .

FROM debian:bullseye-slim

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  build-essential logrotate automake \
  libxml2-dev libpqxx-dev libmemcached-dev libboost-dev libboost-regex-dev \
  libboost-program-options-dev libboost-date-time-dev libboost-filesystem-dev \
  libboost-system-dev libboost-locale-dev libfcgi-dev libcrypto++-dev zlib1g-dev \
  libtool gettext-base libyajl-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /srv/openstreetmap-cgimap

COPY ./openstreetmap-cgimap/ /srv/openstreetmap-cgimap/

WORKDIR /srv/openstreetmap-cgimap

RUN ./autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-yajl
RUN make -j 4

ENTRYPOINT ["tail", "-f", "/dev/null"]
