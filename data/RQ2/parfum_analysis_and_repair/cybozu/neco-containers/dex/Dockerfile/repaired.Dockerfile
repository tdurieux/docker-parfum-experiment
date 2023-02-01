# dex container image

# Stage1: build from source
FROM quay.io/cybozu/golang:1.17-focal AS build

ARG DEX_VERSION=2.30.2

WORKDIR /work/dex/
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -sSLf https://github.com/dexidp/dex/archive/v${DEX_VERSION}.tar.gz | \
        tar zxf - -C /work/dex --strip-components 1

RUN make bin/dex VERSION=v${DEX_VERSION}

# Stage2: setup runtime container