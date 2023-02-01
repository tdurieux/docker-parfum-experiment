FROM alpine AS builder

# Download QEMU, see https://github.com/docker/hub-feedback/issues/1261
ENV QEMU_URL https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-arm.tar.gz
RUN apk add --no-cache curl && curl -f -L ${QEMU_URL} | tar zxvf - -C . --strip-components 1

FROM ghcr.io/linuxserver/baseimage-alpine:arm32v7-3.12 AS python

# Add QEMU
COPY --from=builder qemu-arm-static /usr/bin

RUN apk add --no-cache build-base python3 python3-dev py3-pip musl-dev gcc && \
    echo "*********** install python packages ***********" && \
	pip install --no-cache-dir wheel && \
	pip wheel --wheel-dir=/root/wheels \
		yq \
		mutagen \
		r128gain \
		mediafile \
		confuse \
		requests \
		https://github.com/beetbox/beets/tarball/master \
		deemix

FROM ghcr.io/linuxserver/baseimage-alpine:arm32v7-3.12

# Add QEMU
COPY --from=builder qemu-arm-static /usr/bin
# Add Python Wheels
COPY --from=python /root/wheels /root/wheels

ENV TITLE="Automated Music Downloader (AMD)"
ENV TITLESHORT="AMD"
ENV VERSION="1.1.10"
ENV MBRAINZMIRROR="https://musicbrainz.org"
ENV XDG_CONFIG_HOME="/config/deemix/xdg"
ENV DOWNLOADMODE="wanted"
ENV FALLBACKSEARCH="True"

RUN apk add --no-cache \
    bash \
    ca-certificates \
    curl \
    jq \
    flac \
    eyed3 \
    opus-tools \
    python3 \
    findutils \
    py3-pip \
    musl-dev \
    gcc \
    ffmpeg && \
    echo "************ install python packages ************" && \
    pip install --no-cache-dir \
      --no-index \
      --find-links=/root/wheels \
		yq \
		mutagen \
		r128gain \
		mediafile \
		confuse \
		requests \
		https://github.com/beetbox/beets/tarball/master \
		deemix && \
	echo "************ setup dl client config directory ************" && \
	echo "************ make directory ************" && \
	mkdir -p "${XDG_CONFIG_HOME}/deemix"

    # copy local files
COPY root/ /

WORKDIR /config

# ports and volumes
VOLUME /config
