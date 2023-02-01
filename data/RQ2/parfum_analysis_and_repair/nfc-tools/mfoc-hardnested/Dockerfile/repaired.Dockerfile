FROM ubuntu:18.04

WORKDIR /mfoc


RUN set -e; \
    apt-get update; \
    apt-get install --no-install-recommends -y file build-essential autoconf pkg-config automake libnfc-dev liblzma-dev && rm -rf /var/lib/apt/lists/*;


# Install gcc
ARG COMPILER=gcc-8

RUN set -e; \
    apt-get update; \
    apt-get install --no-install-recommends -y $COMPILER && rm -rf /var/lib/apt/lists/*;


COPY . .

ENV CC=${COMPILER}

RUN autoreconf -vis
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make
RUN file ./src/mfoc-hardnested
RUN ./src/mfoc-hardnested -h
