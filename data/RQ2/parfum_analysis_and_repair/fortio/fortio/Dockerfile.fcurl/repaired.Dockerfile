# Build the binaries in larger image
FROM docker.io/fortio/fortio.build:v41 as build
WORKDIR /go/src/fortio.org
COPY . fortio
# fcurl should not need vendor/no dependencies
RUN make -C fortio official-build-version BUILD_DIR=/build OFFICIAL_TARGET=fortio.org/fortio/fcurl OFFICIAL_BIN=../fcurl.bin
# Minimal image with just the binary and certs