# Build Wine from source in builder container
# See https://wiki.winehq.org/Building_Wine

ARG IMAGE_TAG=latest
FROM ubuntu:$IMAGE_TAG as build-config

ENV DEBIAN_FRONTEND="noninteractive"
RUN sed -i -E 's/^# deb-src /deb-src /g' /etc/apt/sources.list \
    && apt-get update \
    && apt-get install --no-install-recommends -y git \
    && apt-get build-dep -y wine && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /wine-dirs/wine-build \
    && git clone --depth=1 --shallow-submodules git://source.winehq.org/git/wine.git /wine-dirs/wine-source

ENV CC=clang
ENV CXX=clang
ENV CFLAGS="-I/usr/local/include"
ENV LDFLAGS="-L/usr/local/lib"

WORKDIR /wine-dirs/wine-build
RUN ../wine-source/configure


FROM build-config AS builder

RUN make -j "$(nproc)"
RUN mkdir -p /wine-dirs/wine-install \
   && make install DESTDIR=/wine-dirs/wine-install


FROM scottyhardy/docker-remote-desktop:latest as main-base

RUN apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        cabextract \
        git \
        gosu \
        gpg-agent \
        locales \
        p7zip \
        pulseaudio \
        pulseaudio-utils \
        sudo \
        tzdata \
        unzip \
        wget \
        winbind \
        xvfb \
        zenity \
    && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

COPY pulse-client.conf /root/pulse/client.conf
COPY entrypoint.sh /usr/bin/entrypoint


# Checkpoint builds are used in CI to circumvent 6hr time-out on Github workflow jobs
FROM build-config AS ci-builder
COPY entrypoint_ci_builder.sh /usr/bin/entrypoint
ENTRYPOINT ["/usr/bin/entrypoint"]


# Final image for CI
FROM main-base as ci-final

COPY wine-build/wine-install/ /
ENTRYPOINT ["/usr/bin/entrypoint"]


# Build the final image
FROM main-base

COPY --from=builder /wine-dirs/wine-install/ /
ENTRYPOINT ["/usr/bin/entrypoint"]
