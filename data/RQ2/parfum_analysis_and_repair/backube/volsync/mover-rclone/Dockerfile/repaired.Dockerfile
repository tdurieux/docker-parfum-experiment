# Build rclone
FROM golang:1.18 as builder
USER root

WORKDIR /workspace

ARG RCLONE_VERSION=v1.58.1
# hash: git rev-list -n 1 ${RCLONE_VERSION}
ARG RCLONE_GIT_HASH=02f04b08bd26b50dfbfb07672c926e49bd070573

RUN git clone --depth 1 -b ${RCLONE_VERSION} https://github.com/rclone/rclone.git

WORKDIR /workspace/rclone

# Make sure the Rclone version tag matches the git hash we're expecting
RUN /bin/bash -c "[[ $(git rev-list -n 1 HEAD) == ${RCLONE_GIT_HASH} ]]"

# We don't vendor modules. Enforce that behavior
ENV GOFLAGS=-mod=readonly
# Remove link flag that strips symbols so that we can verify crypto libs
RUN sed -i 's/--ldflags "-s /--ldflags "/g' Makefile
RUN make rclone

# Verify that FIPS crypto libs are accessible
# Check removed since official images don't support boring crypto
#RUN nm rclone | grep -q goboringcrypto

# Build final container