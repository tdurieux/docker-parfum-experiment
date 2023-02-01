FROM ubuntu:14.04

RUN apt-get update && \
    apt-get install --no-install-recommends -y git build-essential libncurses5-dev libslang2-dev gettext zlib1g-dev libselinux1-dev debhelper lsb-release pkg-config po-debconf autoconf automake autopoint libtool bison && rm -rf /var/lib/apt/lists/*;

RUN git clone git://git.kernel.org/pub/scm/utils/util-linux/util-linux.git util-linux
RUN cd util-linux/ && \
    ./autogen.sh && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --without-python --disable-all-programs --enable-nsenter && \
    make

RUN mv /util-linux/nsenter /nsenter
