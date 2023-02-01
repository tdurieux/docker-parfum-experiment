FROM fedora:23

MAINTAINER Mike Kinney <mike.kinney@gmail.com>

# TODO: change from yum to dnf
RUN yum upgrade -y
RUN yum install -y wget && rm -rf /var/cache/yum
RUN wget https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-6.noarch.rpm
RUN rpm -ivh epel-release-7-6.noarch.rpm
RUN yum install -y autoconf automake gcc-c++ libdb4-cxx libdb4-cxx-devel boost-devel openssl-devel git bzip2 make file sudo tar && rm -rf /var/cache/yum

RUN cd /tmp && \
    wget https://protobuf.googlecode.com/files/protobuf-2.5.0.tar.bz2 && \
    tar xf protobuf-2.5.0.tar.bz2 && \
    cd /tmp/protobuf-2.5.0 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make -Wall -Wwrite-strings -Woverloaded-virtual -Wno-sign-compare && \
    make install && rm protobuf-2.5.0.tar.bz2

RUN echo "/usr/local/lib" >> /etc/ld.so.conf && \
    echo "/usr/lib" >> /etc/ld.so.conf && \
    ldconfig

ENV PKG_CONFIG_PATH /usr/local/lib/pkgconfig:$PKG_CONFIG_PATH

RUN yum install -y qt5-qtbase-devel qt5-qttools-devel qt5-qtwebkit-devel qt5-qtwebsockets qrencode-devel && rm -rf /var/cache/yum

RUN git clone https://github.com/ShieldCoin/shield /coin/git

WORKDIR /coin/git

RUN ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-gui=qt5 && make && mv src/SHIELDd /coin/SHIELDd

WORKDIR /coin
VOLUME ["/coin/home"]

ENV HOME /coin/home

CMD ["/coin/SHIELDd"]

# P2P, RPC
EXPOSE 21103 20103
