ARG PLATFORM=android-23
ARG TOOLCHAIN=arm-linux-androideabi-4.9

FROM rhardih/stand:r17c--$PLATFORM--$TOOLCHAIN

ARG PLATFORM
ENV PLATFORM $PLATFORM
ARG HOST=arm-linux-androideabi

# List of available versions can be found at
# https://www.sqlite.org/src/taglist
ARG VERSION

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y --no-install-recommends install \
  wget \
  tcl \
  autoconf \
  libtool && rm -rf /var/lib/apt/lists/*;

RUN wget -O sqlite-$VERSION.tar.gz \
  https://www.sqlite.org/src/tarball/sqlite.tar.gz?r=version-$VERSION && \
  tar -xzvf sqlite-$VERSION.tar.gz && \
  rm sqlite-$VERSION.tar.gz

WORKDIR /sqlite

ENV PATH $PATH:/$PLATFORM-toolchain/bin

# Acquire newer versions of .guess and .sub files for configure

RUN wget -O config.guess \
  https://raw.githubusercontent.com/gcc-mirror/gcc/master/config.guess

RUN wget -O config.sub \
  https://raw.githubusercontent.com/gcc-mirror/gcc/master/config.sub

# Patch Makefile.am in order to create unversioned library
COPY sqlite3/patches/Makefile.am.patch Makefile.am.patch
RUN patch autoconf/Makefile.am < Makefile.am.patch
RUN autoreconf -vfi

RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
  --host=$HOST \
  --disable-tcl \
  --prefix=/sqlite3-build/

RUN make -j  && make install
