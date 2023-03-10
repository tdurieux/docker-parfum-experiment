FROM debian:stretch

RUN apt-get update && apt-get install --no-install-recommends -y \
	make \
	autoconf \
	automake \
	libtool \
	pkg-config \
	curl \
	mingw-w64 \
	mingw-w64-tools \
	gcc-mingw-w64-x86-64 \
	binutils-mingw-w64-x86-64 \
	mingw-w64-x86-64-dev \
	openjdk-8-jdk \
	zip && rm -rf /var/lib/apt/lists/*;

ARG LIBLOUIS_VERSION=master
ARG LIBXML2_VERSION=2.9.9

WORKDIR /root/src/
RUN curl -f -L ftp://xmlsoft.org/libxml2/libxml2-${LIBXML2_VERSION}.tar.gz | tar zx
WORKDIR /root/src/libxml2-${LIBXML2_VERSION}
RUN autoreconf -i
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-zlib=no --with-iconv=no --with-python=no --with-threads=no --host x86_64-w64-mingw32 --prefix=/tmp/liblouis-mingw32msvc
RUN make
RUN make install

WORKDIR /root/src/
RUN curl -f -L https://github.com/liblouis/liblouis/archive/${LIBLOUIS_VERSION}.tar.gz | tar zx
WORKDIR /root/src/liblouis-${LIBLOUIS_VERSION}
RUN ./autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-ucs4 --host x86_64-w64-mingw32 --prefix=/tmp/liblouis-mingw32msvc
RUN make
RUN make install

ADD . /root/src/liblouisutdml
WORKDIR /root/src/liblouisutdml
ENV PKG_CONFIG_PATH=/tmp/liblouis-mingw32msvc/lib/pkgconfig
ENV CFLAGS=-I/usr/lib/jvm/java-8-openjdk-amd64/include/
RUN ./autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-java-bindings --host x86_64-w64-mingw32 --prefix=/tmp/liblouis-mingw32msvc
RUN make
RUN make install
