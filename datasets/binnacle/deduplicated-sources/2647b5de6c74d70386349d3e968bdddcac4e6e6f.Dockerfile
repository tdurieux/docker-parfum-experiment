ARG BUILD_FROM=hassioaddons/base:4.0.1
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
ARG BUILD_ARCH=amd64
RUN \
    apk add --no-cache \
        lua-resty-http=0.13-r0 \
        nginx-mod-http-lua=1.16.0-r2 \
        nginx=1.16.0-r2 \
    \
    && if [ "${BUILD_ARCH}" = "aarch64" ]; then ARCH="arm64"; fi \
    && if [ "${BUILD_ARCH}" = "armhf" ]; then ARCH="arm"; fi \
    && if [ "${BUILD_ARCH}" = "armv7" ]; then ARCH="arm"; fi \
    && if [ "${BUILD_ARCH}" = "amd64" ]; then ARCH="amd64"; fi \
    \
    && curl -L -s \
        "https://github.com/portainer/portainer/releases/download/1.21.0/portainer-1.21.0-linux-${ARCH}.tar.gz" \
        | tar zxvf - -C /opt/ \
    \
    && rm -fr \
        /etc/nginx

# Copy root filesystem
COPY rootfs /

# Build arguments
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="portainer" \
    io.hass.description="Manage your Docker environment with ease" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.label-schema.description="Manage your Docker environment with ease" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Portainer" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://community.home-assistant.io/t/community-hass-io-add-on-portainer/68836?u=frenck" \
    org.label-schema.usage="https://github.com/hassio-addons/addon-portainer/tree/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/hassio-addons/addon-portainer" \
    org.label-schema.vendor="Community Hass.io Add-ons"
