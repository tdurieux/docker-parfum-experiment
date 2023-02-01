# -*- coding: utf-8 -*-
FROM ubuntu:18.04 AS build-env
MAINTAINER Takahiro INOUE <takahiro.inoue@aist.go.jp>

ENV JOBS 4

WORKDIR /tmp

####
## requirement for docker build
####

RUN apt-get update && \
    apt-get -y --no-install-recommends install \
      build-essential \
      cmake \
      git \
      qt5-default \
      libeigen3-dev && rm -rf /var/lib/apt/lists/*;

####
## application deploy
####

ADD . .

RUN mkdir build     && \
    cd build        && \
    cmake ..        && \
    make -j ${JOBS}

FROM ubuntu:18.04
MAINTAINER Takahiro INOUE <takahiro.inoue@aist.go.jp>

COPY --from=build-env /tmp/build/unblending-cli/unblending-cli /usr/local/bin/unblending-cli

RUN apt-get update && \
    apt-get -y --no-install-recommends install \
      qt5-default && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT [ "unblending-cli" ]
