# Build Fotomat RPM for CentOS/RHEL based distros using Docker.
#
# Run: dist/build centos:6
#
# And you'll end up with a fotomat*.rpm in the current directory.

ARG BASE
FROM $BASE

# Update packages and add a tool for building RPMs.
RUN yum -y update && \
    yum -y install rpm-build && rm -rf /var/cache/yum

# Apt-get our dependencies, download, build, and install VIPS, and download and install Go.
ADD preinstall.sh /app/src/github.com/die-net/fotomat/

RUN CFLAGS="-O2 -ftree-vectorize -msse2 -ffast-math -fPIE" \
    LDFLAGS="-lstdc++" \
    VIPS_OPTIONS="--disable-shared --enable-static" \
    /app/src/github.com/die-net/fotomat/preinstall.sh

# Add the rest of our code.
COPY . /app/src/github.com/die-net/fotomat/

WORKDIR /app/src/github.com/die-net/fotomat/

# Build and install Fotomat
RUN PKG_CONFIG_PATH=/usr/local/lib/pkgconfig GOPATH=/app CGO_LDFLAGS_ALLOW="-Wl,--export-dynamic" \
    /usr/local/go/bin/go install -ldflags="-s -w" -tags vips_static ./...

# Test fotomat
RUN PKG_CONFIG_PATH=/usr/local/lib/pkgconfig GOPATH=/app CGO_LDFLAGS_ALLOW="-Wl,--export-dynamic" \
    /usr/local/go/bin/go test -tags vips_static -v ./...

# Update specfile version and use it to build binary RPM.
RUN perl -ne '/FotomatVersion.*\b(\d+\.\d+\.\d+)/ and print "$1\n"' cmd/fotomat/version.go | \
    xargs -i{} perl -p -i~ -e 's/(^Version:\s+)\d+\.\d+\.\d+/${1}{}/' dist/rpm/fotomat.spec
RUN rpmbuild -bb dist/rpm/fotomat.spec
