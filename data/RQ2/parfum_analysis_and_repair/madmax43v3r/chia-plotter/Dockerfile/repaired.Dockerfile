# Compiler image
# -------------------------------------------------------------------------------------------------
FROM alpine:3.13.5 AS compiler

WORKDIR /root

RUN apk --no-cache add \
    gcc \
    g++ \
    build-base \
    cmake \
    gmp-dev \
    libsodium-dev \
    libsodium-static \
    git

COPY . .
RUN /bin/sh ./make_devel.sh

# Runtime image
# -------------------------------------------------------------------------------------------------