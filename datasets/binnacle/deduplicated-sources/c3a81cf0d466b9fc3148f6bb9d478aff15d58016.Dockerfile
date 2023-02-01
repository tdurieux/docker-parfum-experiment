ARG ARCH=amd64

# The node version here should match the version of the runtime image which is
# specified in the base-image subdirectory in the project
FROM balenalib/raspberry-pi-node:10-run as rpi-base
FROM balenalib/armv7hf-node:10-run as armv7hf-base
FROM balenalib/aarch64-node:10-run as aarch64-base
RUN [ "cross-build-start" ]
RUN sed -i '/security.debian.org jessie/d' /etc/apt/sources.list
RUN [ "cross-build-end" ]

FROM balenalib/amd64-node:10-run as amd64-base
RUN echo '#!/bin/sh\nexit 0' > /usr/bin/cross-build-start && chmod +x /usr/bin/cross-build-start \
	&& echo '#!/bin/sh\nexit 0' > /usr/bin/cross-build-end && chmod +x /usr/bin/cross-build-end

FROM balenalib/i386-node:10-run as i386-base
RUN echo '#!/bin/sh\nexit 0' > /usr/bin/cross-build-start && chmod +x /usr/bin/cross-build-start \
	&& echo '#!/bin/sh\nexit 0' > /usr/bin/cross-build-end && chmod +x /usr/bin/cross-build-end

FROM resin/i386-node:6.13.1-slim as i386-nlp-base
RUN echo '#!/bin/sh\nexit 0' > /usr/bin/cross-build-start && chmod +x /usr/bin/cross-build-start \
	&& echo '#!/bin/sh\nexit 0' > /usr/bin/cross-build-end && chmod +x /usr/bin/cross-build-end \
	# TODO: Move this to a balenalib image so this isn't necessary
	&& sed -i '/jessie-updates/{s/^/#/}' /etc/apt/sources.list

# A little hack to make this work with the makefile
FROM $ARCH-base AS node-build
FROM $ARCH-base AS node-deps

ARG ARCH
ARG VERSION=master
ARG DEFAULT_MIXPANEL_TOKEN=bananasbananas

RUN [ "cross-build-start" ]

WORKDIR /usr/src/app

RUN apt-get update && apt-get install ca-certificates \
	iptables libnss-mdns nodejs rsync git python make wget g++ \
	kmod vim

COPY package*.json ./

# i386-nlp doesn't have an npm version which supports ci
RUN if [ $ARCH = "i386-nlp" ]; then \
 JOBS=MAX npm install --no-optional --unsafe-perm; \
else \
 JOBS=MAX npm ci --no-optional --unsafe-perm; \
fi

COPY src src/
COPY typings typings/
COPY tsconfig.json tsconfig.release.json hardcode-migrations.js fix-jsonstream.js ./

RUN npm run build:debug
RUN mkdir -p dist && echo "require('../build/app.js')" > dist/app.js

COPY entry.sh .

RUN mkdir -p rootfs-overlay && \
	(([ ! -d rootfs-overlay/lib64 ] && ln -s /lib rootfs-overlay/lib64) || true)

ENV CONFIG_MOUNT_POINT=/boot/config.json \
	LED_FILE=/dev/null \
	SUPERVISOR_IMAGE=resin/$ARCH-supervisor \
	VERSION=$VERSION \
	DEFAULT_MIXPANEL_TOKEN=$DEFAULT_MIXPANEL_TOKEN
COPY avahi-daemon.conf /etc/avahi/avahi-daemon.conf

VOLUME /data
HEALTHCHECK --interval=5m --start-period=1m --timeout=30s --retries=3 \
	CMD wget -qO- http://127.0.0.1:${LISTEN_PORT:-48484}/v1/healthy || exit 1

RUN [ "cross-build-end" ]

CMD DEBUG=1 ./entry.sh || while true; do echo 'Supervisor runtime exited - waiting for changes'; sleep 100; done;
