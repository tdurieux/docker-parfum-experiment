ARG BUILD_FROM=arm64v8

FROM ${BUILD_FROM}/ubuntu:16.04
#LABEL maintainer="Jeremy Lan <air.petrichor@gmail.com>" version="0.1.1" \
#  description="This is mvs-org/metaverse image" website="http://mvs.org/" \
#  , etc..."

RUN echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends \
  && echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y sudo wget curl net-tools ca-certificates unzip && rm -rf /var/lib/apt/lists/*;

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y git-core automake cmake autoconf libtool build-essential pkg-config libtool apt-utils && rm -rf /var/lib/apt/lists/*;

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y mpi-default-dev libicu-dev libbz2-dev zlib1g-dev openssl libssl-dev libgmp-dev \
  && rm -rf /var/lib/apt/lists/*

COPY ./ /tmp/metaverse/

# setup gmp link => without-bignum
ENV IS_TRAVIS_LINUX 1

RUN cd /tmp/metaverse && /bin/bash install_dependencies.sh --build-arm --build-boost --build-upnpc

RUN cd /tmp/metaverse \
  && mkdir -p build && cd build && cmake .. && make -j2 && make install \
  && rm -rf /tmp/metaverse/build \
  && rm -rf /tmp/metaverse/build-mvs-dependencies

# TODO...
# Should has `make test` here

RUN cd /tmp/metaverse/utils && /bin/bash setup_mvs_conf.sh

VOLUME [~/.metaverse]

# P2P Network
EXPOSE 5251
# JSON-RPC CALL
EXPOSE 8820
# Websocket notifcations
EXPOSE 8821

ENTRYPOINT ["/usr/local/bin/mvsd"]
