FROM ubuntu:xenial
LABEL Description="Aktualizr testing dockerfile for Ubuntu Xenial with p11"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y install --no-install-suggests --no-install-recommends debian-archive-keyring && rm -rf /var/lib/apt/lists/*;
RUN echo "deb http://deb.debian.org/debian  stretch-backports main" > /etc/apt/sources.list.d/stretch-backports.list

# It is important to run these in the same RUN command, because otherwise
# Docker layer caching breaks us
RUN apt-get update && apt-get -y install --no-install-suggests --no-install-recommends \
  apt-transport-https \
  autoconf \
  asn1c \
  automake \
  bison \
  ccache \
  cmake \
  curl \
  e2fslibs-dev \
  g++ \
  gcc \
  git \
  jq \
  lcov \
  libarchive-dev \
  libboost-dev \
  libboost-log-dev \
  libboost-program-options-dev \
  libboost-system-dev \
  libboost-test-dev \
  libboost-thread-dev \
  libcurl4-openssl-dev \
  libengine-pkcs11-openssl \
  libexpat1-dev \
  libffi-dev \
  libfuse-dev \
  libglib2.0-dev \
  libgpgme11-dev \
  libgtest-dev \
  liblzma-dev \
  libsodium-dev \
  libsqlite3-dev \
  libssl-dev \
  libtool \
  lshw \
  make \
  ninja-build \
  net-tools \
  opensc \
  pkg-config \
  psmisc \
  python3-dev \
  python3-gi \
  python3-openssl \
  python3-pip \
  python3-venv \
  sqlite3 \
  strace \
  wget \
  zip && rm -rf /var/lib/apt/lists/*;

# Includes workaround for this bug:
# https://bugs.launchpad.net/ubuntu/+source/valgrind/+bug/1501545
# https://stackoverflow.com/questions/37032339/valgrind-unrecognised-instruction
RUN echo "deb http://archive.ubuntu.com/ubuntu/ bionic main multiverse restricted universe" > /etc/apt/sources.list.d/bionic.list
RUN apt-get update && apt-get -y --no-install-recommends install \
  libp11-3 \
  libp11-dev \
  softhsm2 \
  valgrind && rm -rf /var/lib/apt/lists/*;

WORKDIR /ostree
RUN git init && git remote add origin https://github.com/ostreedev/ostree
RUN git fetch origin v2018.9 && git checkout FETCH_HEAD
RUN NOCONFIGURE=1 ./autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" CFLAGS='-Wno-error=missing-prototypes' --with-libarchive --disable-gtk-doc --disable-gtk-doc-html --disable-gtk-doc-pdf --disable-man --with-builtin-grub2-mkconfig --with-curl --without-soup --prefix=/usr
RUN make VERBOSE=1 -j4
RUN make install

RUN useradd testuser

WORKDIR /
