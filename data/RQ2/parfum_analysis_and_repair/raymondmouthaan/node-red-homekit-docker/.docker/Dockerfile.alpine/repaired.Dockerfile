ARG ARCH
ARG NODE_VERSION
ARG TAG_SUFFIX
ARG NODE_RED_BASE_TAG

FROM nodered/node-red:${NODE_RED_BASE_TAG}-${NODE_VERSION}${TAG_SUFFIX}-${ARCH}

ARG QEMU_ARCH
ARG S6_ARCH
ARG S6_VERSION
ARG FFMPEG_ARCH
ARG HOMEKIT_BRIDGED_VERSION

LABEL org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.docker.dockerfile=".docker/Dockerfile.alpine" \
    org.label-schema.license="Apache-2.0" \
    org.label-schema.name="Node-RED" \
    org.label-schema.version=${BUILD_VERSION} \
    org.label-schema.description="Low-code programming for event-driven applications." \
    org.label-schema.url="https://nodered.org" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-type="Git" \
    org.label-schema.vcs-url="https://github.com/RaymondMouthaan/node-red-homekit-docker.git" \
    org.label-schema.arch=${ARCH} \
    authors="Raymond Mouthaan"

USER root

# QEMU - Quick Emulation
COPY tmp/qemu-$QEMU_ARCH-static /usr/bin/qemu-$QEMU_ARCH-static

# root filesystem
COPY rootfs /

# Install tools
RUN set -ex \
    && apk add --no-cache --virtual .run-deps \
      avahi-compat-libdns_sd \
      avahi-dev \
      dbus \
    && npm set package-lock=false

# s6 overlay
RUN curl -f -L -s https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-${S6_ARCH}.tar.gz | tar xvzf - -C /

# ffmpeg-for-homebridge
RUN curl -Lf# https://github.com/homebridge/ffmpeg-for-homebridge/releases/latest/download/ffmpeg-alpine-${FFMPEG_ARCH}.tar.gz | tar xzf - -C / --no-same-owner

COPY package.json .
RUN npm install --unsafe-perm --no-update-notifier --only=production && npm cache clean --force;

# Add passport openidconnect strategy to allow usage of OIDC for authentication at Node RED editor & dashboard
RUN npm install passport-openidconnect \
    && npm install jwt-decode && npm cache clean --force;

# Modify jaredhanson/passport-openidconnect to retrieve profile scope
# Apply modified file /usr/src/node-red/node_modules/passport-openidconnect/lib/strategy.js
# Modified file adds profile in line 244 to get userinfo
COPY strategy.js /usr/src/node-red/node_modules/passport-openidconnect/lib/strategy.js

ENTRYPOINT [ "/init" ]
