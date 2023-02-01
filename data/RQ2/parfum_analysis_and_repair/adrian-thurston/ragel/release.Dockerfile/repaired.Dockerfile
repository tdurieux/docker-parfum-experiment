#
# This dockerfile demonstrates building ragel from release tarballs.
#

FROM ubuntu:focal AS build

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update && apt-get install --no-install-recommends -y \
	gpg g++ gcc make curl && rm -rf /var/lib/apt/lists/*;

RUN curl -f https://www.colm.net/files/thurston.asc | gpg --batch --import -

WORKDIR /build
ENV COLM_VERSION=0.14.7
RUN curl -f -O https://www.colm.net/files/colm/colm-${COLM_VERSION}.tar.gz
RUN curl -f -O https://www.colm.net/files/colm/colm-${COLM_VERSION}.tar.gz.asc
RUN gpg --batch --verify colm-${COLM_VERSION}.tar.gz.asc colm-${COLM_VERSION}.tar.gz && rm colm-${COLM_VERSION}.tar.gz.asc
RUN tar -zxvf colm-${COLM_VERSION}.tar.gz && rm colm-${COLM_VERSION}.tar.gz
WORKDIR /build/colm-${COLM_VERSION}
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/opt/colm/colm --disable-manual
RUN make
RUN make install

WORKDIR /build
ENV RAGEL_VERSION=7.0.4
RUN curl -f -O https://www.colm.net/files/ragel/ragel-${RAGEL_VERSION}.tar.gz
RUN curl -f -O https://www.colm.net/files/ragel/ragel-${RAGEL_VERSION}.tar.gz.asc
RUN gpg --batch --verify ragel-${RAGEL_VERSION}.tar.gz.asc ragel-${RAGEL_VERSION}.tar.gz && rm ragel-${RAGEL_VERSION}.tar.gz.asc
RUN tar -zxvf ragel-${RAGEL_VERSION}.tar.gz && rm ragel-${RAGEL_VERSION}.tar.gz
WORKDIR /build/ragel-${RAGEL_VERSION}
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/opt/colm/ragel --with-colm=/opt/colm/colm --disable-manual
RUN make
RUN make install
