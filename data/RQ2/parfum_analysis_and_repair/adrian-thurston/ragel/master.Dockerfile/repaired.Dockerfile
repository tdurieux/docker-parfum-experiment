#
# This dockerfile demonstrates a minimal build of ragel off the master branch.
# No manual or testing dependencies are installed.
#
FROM ubuntu:focal AS build

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update && apt-get install --no-install-recommends -y \
	git libtool autoconf automake gcc g++ make && rm -rf /var/lib/apt/lists/*;

WORKDIR /devel
RUN git clone https://github.com/adrian-thurston/colm.git
WORKDIR /devel/colm
RUN ./autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/pkgs/colm
RUN make install

COPY . /devel/ragel
WORKDIR /devel/ragel
RUN ./autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/pkgs/ragel --with-colm=/pkgs/colm
RUN make install
