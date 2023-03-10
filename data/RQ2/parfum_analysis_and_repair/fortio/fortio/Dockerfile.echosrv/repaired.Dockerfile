# Build the binaries in larger image
FROM docker.io/fortio/fortio.build:v41 as build
WORKDIR /go/src/fortio.org
COPY . fortio
RUN make -C fortio official-build-version BUILD_DIR=/build OFFICIAL_TARGET=fortio.org/fortio/echosrv OFFICIAL_BIN=../echosrv.bin
# Minimal image with just the binary