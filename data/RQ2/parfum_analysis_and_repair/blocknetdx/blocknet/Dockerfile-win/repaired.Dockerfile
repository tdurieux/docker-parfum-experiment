FROM ubuntu:bionic

ARG cores=8
ENV ecores=$cores

RUN apt update \
  && apt install -y --no-install-recommends \
     software-properties-common \
     ca-certificates \
     wget curl git python vim \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN add-apt-repository ppa:bitcoin/bitcoin \
  && apt update \
  && apt install -y --no-install-recommends \
     build-essential libtool autotools-dev bsdmainutils \
     libevent-dev autoconf automake pkg-config libssl-dev \
     libdb4.8-dev libdb4.8++-dev \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# mingw
RUN apt update \
  && apt install -y --no-install-recommends \
     g++-mingw-w64-x86-64 nsis zip \
  && update-alternatives --set x86_64-w64-mingw32-g++ /usr/bin/x86_64-w64-mingw32-g++-posix \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PROJECTDIR=/opt/blocknetdx/blocknet
ENV BASEPREFIX=$PROJECTDIR/depends
ENV DISTDIR=/opt/blocknetdx/dist
ENV HOST=x86_64-w64-mingw32

# Download depends
RUN mkdir -p $PROJECTDIR \
  && cd $PROJECTDIR \
  && wget -nv https://s3.us-east-2.amazonaws.com/devbuilds.blocknetprotocol.com/depends/depends-v4.2.0-win-bionic.tar.gz \
  && [ "$(printf '1a10012c4fd13cc1eb671ac5a3919cd42c86b9ff90f875ce8fa153a77871170c depends-v4.2.0-win-bionic.tar.gz' | sha256sum -c)" = "depends-v4.2.0-win-bionic.tar.gz: OK" ] || $(echo "depends checksum failed"; exit 1)

# Copy source files
COPY . $PROJECTDIR/

# Build source
RUN mkdir -p $DISTDIR \
  && cd $PROJECTDIR \
  && rm -r $BASEPREFIX \
  && tar xzf depends-v4.2.0-win-bionic.tar.gz \
  && chmod +x ./autogen.sh; rm depends-v4.2.0-win-bionic.tar.gz sync \
  && ./autogen.sh \
  && CONFIG_SITE=$BASEPREFIX/$HOST/share/config.site ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/ --disable-ccache --disable-maintainer-mode --disable-dependency-tracking --enable-reduce-exports --disable-bench --disable-gui-tests \
  && make clean \
  && echo "Building with cores: $ecores" \
  && make -j$ecores \
  && make deploy \
  && make install DESTDIR=$DISTDIR \
  && cp *win64-setup.exe $DISTDIR/bin/blocknet-win64-setup.exe \
  && make clean

WORKDIR /opt/blocknetdx/dist

# Port, RPC, Test Port, Test RPC
EXPOSE 41412 41414 41474 41419
