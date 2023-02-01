# Dockerfile - Debian 9 Stretch Fat - DEB version
# https://github.com/openresty/docker-openresty
#
# This builds upon the base OpenResty Stretch image,
# adding useful packages and utilities.
#
# Currently it just adds the openresty-opm package.
#

ARG RESTY_IMAGE_BASE="openresty/openresty"
ARG RESTY_IMAGE_TAG="stretch"

FROM ${RESTY_IMAGE_BASE}:${RESTY_IMAGE_TAG}

LABEL maintainer="Evan Wies <evan@neomantra.net>"

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        openresty-opm
