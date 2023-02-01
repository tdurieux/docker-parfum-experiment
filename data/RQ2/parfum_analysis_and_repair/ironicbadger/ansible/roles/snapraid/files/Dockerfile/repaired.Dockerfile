FROM debian:jessie
MAINTAINER IronicBadger <ironicbadger@linuxserver.io>
ENV SNAPRAID_VERSION=10.0

# Builds SnapRAID from source
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install --no-install-recommends -y \
    gcc \
    git \
    make \
    checkinstall \
    curl && \
  curl -f -LO https://github.com/amadvance/snapraid/releases/download/v$SNAPRAID_VERSION/snapraid-$SNAPRAID_VERSION.tar.gz && \
  tar -xvf snapraid-$SNAPRAID_VERSION.tar.gz && \
  cd snapraid-$SNAPRAID_VERSION && \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
  make -j8 && \
  make -j8 check && \
  checkinstall -Dy --install=no --nodoc && \
  mkdir /artifact && \
  cp *.deb /artifact/snapraid-from-source.deb && rm snapraid-$SNAPRAID_VERSION.tar.gz && rm -rf /var/lib/apt/lists/*;
