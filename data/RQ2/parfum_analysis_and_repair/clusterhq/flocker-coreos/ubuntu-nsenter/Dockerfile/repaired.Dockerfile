FROM ubuntu:14.04
MAINTAINER Kai Davenport <kai.davenport@clusterhq.com>

RUN apt-get update && apt-get install --no-install-recommends -y git build-essential libncurses5-dev libslang2-dev gettext zlib1g-dev libselinux1-dev debhelper lsb-release pkg-config po-debconf autoconf automake autopoint libtool && rm -rf /var/lib/apt/lists/*;
RUN git clone git://git.kernel.org/pub/scm/utils/util-linux/util-linux.git util-linux
RUN cd util-linux/ && ./autogen.sh
RUN cd util-linux/ && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --without-python --disable-all-programs --enable-nsenter
RUN cd util-linux/ && make
RUN cp util-linux/nsenter /usr/bin/nsenter