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
     librsvg2-bin libtiff-tools bsdmainutils cmake imagemagick \
     libcap-dev libz-dev libbz2-dev python-setuptools \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install llvm
RUN apt update \
  && apt install -y --no-install-recommends \
     llvm \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PROJECTDIR=/opt/blocknetdx/BlockDX
ENV BASEPREFIX=$PROJECTDIR/depends
ENV DISTDIR=/opt/blocknetdx/dist
ENV HOST=x86_64-apple-darwin14

# Download depends
RUN mkdir -p $PROJECTDIR \
  && cd $PROJECTDIR \
  && wget -nv https://s3.us-east-2.amazonaws.com/devbuilds.blocknetprotocol.com/depends/depends-3.11.1-dev-mac.tar.gz \
  && [ "$(printf '9bb4b8c092a3ced41f0ef636c0bb16ca10fa4f8a624b95c18800b9d7b4d096dd depends-3.11.1-dev-mac.tar.gz' | sha256sum -c)" = "depends-3.11.1-dev-mac.tar.gz: OK" ] || $(echo "depends checksum failed"; exit 1)

# Copy source files
#RUN cd /opt/blocknetdx \
#  && git clone --depth 1 --branch 3.12.1 https://github.com/BlocknetDX/blocknet.git tmp \
#  && mv tmp/* BlockDX/
COPY . $PROJECTDIR/

# Build source
RUN mkdir -p $DISTDIR \
  && cd $PROJECTDIR \
  && rm -r $BASEPREFIX \
  && tar xzf depends-3.11.1-dev-mac.tar.gz \
  && chmod +x ./autogen.sh; sync \
  && ./autogen.sh \
  && CONFIG_SITE=$BASEPREFIX/$HOST/share/config.site ./configure CFLAGS="-g -O0" CXXFLAGS="-g -O0" --with-gui=qt5 --enable-debug --prefix=/ \
  && make clean \
  && echo "Building with cores: $ecores" \
  && make -j$ecores \
  && mkdir -p $DISTDIR/bin && llvm-dsymutil-6.0 src/qt/blocknetdx-qt -o $DISTDIR/bin/blocknetdx-qt.dSYM \
  && make install DESTDIR=$DISTDIR \
  && make clean

WORKDIR /opt/blocknetdx/dist

# Port, RPC, Test Port, Test RPC
EXPOSE 41412 41414 41474 41419
