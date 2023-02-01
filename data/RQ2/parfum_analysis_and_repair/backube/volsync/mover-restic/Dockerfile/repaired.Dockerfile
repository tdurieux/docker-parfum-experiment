# Build restic
FROM golang:1.18 as builder
USER root

WORKDIR /workspace

ARG RESTIC_VERSION=v0.13.1
# hash: git rev-list -n 1 ${RESTIC_VERSION}
ARG RESTIC_GIT_HASH=594f155eb6faf57dd02508283f8d84dfa4c125a7

RUN git clone --depth 1 -b ${RESTIC_VERSION} https://github.com/restic/restic.git

WORKDIR /workspace/restic

# Make sure the Restic version tag matches the git hash we're expecting
RUN /bin/bash -c "[[ $(git rev-list -n 1 HEAD) == ${RESTIC_GIT_HASH} ]]"

# We don't vendor modules. Enforce that behavior
ENV GOFLAGS=-mod=readonly
# Preserve symbols so that we can verify crypto libs
RUN sed -i 's/preserveSymbols := false/preserveSymbols := true/g' build.go
RUN go run build.go --enable-cgo

# Verify that FIPS crypto libs are accessible
# Check removed since official images don't support boring crypto
#RUN nm restic | grep -q goboringcrypto

# Build final container