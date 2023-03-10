# Build Fotomat dpkg for Debian or Ubuntu using Docker
#
# Run: dist/build debian:buster
#
# And you'll end up with a fotomat*.dpkg in the current directory.

ARG BASE
FROM $BASE

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get dist-upgrade -y -q --no-install-recommends && \
    apt-get install -y -q --no-install-recommends fakeroot && rm -rf /var/lib/apt/lists/*;

# Apt-get our dependencies, download, build, and install VIPS, and download and install Go.
ADD preinstall.sh /app/src/github.com/die-net/fotomat/
RUN CFLAGS="-O2 -ftree-vectorize -msse2 -ffast-math -fPIE" \
    VIPS_OPTIONS="--disable-shared --enable-static" \
    /app/src/github.com/die-net/fotomat/preinstall.sh

# Add the rest of our code.
COPY . /app/src/github.com/die-net/fotomat/

WORKDIR /app/src/github.com/die-net/fotomat/

# Build and install Fotomat
RUN GOPATH=/app CGO_LDFLAGS_ALLOW="-Wl,--export-dynamic" /usr/local/go/bin/go install -ldflags="-s -w" -tags vips_static ./...

# Test fotomat
RUN GOPATH=/app CGO_LDFLAGS_ALLOW="-Wl,--export-dynamic" /usr/local/go/bin/go test -tags vips_static -v ./...

# Build the dpkg.
RUN dist/build-dpkg /app/bin/fotomat
