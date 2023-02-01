# 3scale Backend image using the Red Hat 8 Universal Base Image (UBI) for
# minimal space release.
#
# Everything is set up in a single RUN command.
#
# This is based on and tracking the behavior of the more generic Dockerfile.
#
# Knobs you should know about:
#
# - RUBY_VERSION: Ruby version used.
# - BUILD_DEP_PKGS: Packages needed to build/install the project.
# - PUMA_WORKERS: (edit ENV) Default number of Puma workers to serve the app.
#

FROM registry.access.redhat.com/ubi8/ubi-minimal

ARG RUBY_VERSION="2.7"
ARG BUILD_DEPS="tar make file findutils git patch gcc automake autoconf libtool redhat-rpm-config openssl-devel ruby-devel"
ARG PUMA_WORKERS=1

# Set TZ to avoid glibc wasting time with unneeded syscalls
ENV TZ=:/etc/localtime \
    HOME=/home \
    # App-specific env
    RACK_ENV=production \
    CONFIG_SAAS=false \
    CONFIG_LOG_PATH=/tmp/ \
    CONFIG_WORKERS_LOG_FILE=/dev/stdout \
    PUMA_WORKERS=${PUMA_WORKERS}

WORKDIR "${HOME}/app"

# Copy sources