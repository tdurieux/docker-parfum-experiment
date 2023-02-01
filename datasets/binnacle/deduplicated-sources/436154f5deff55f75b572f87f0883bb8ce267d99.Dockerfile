FROM centos:7

MAINTAINER Mike Kinney <mike.kinney@gmail.com>

RUN yum upgrade -y 
RUN yum install -y wget 
RUN yum install -y epel-release
RUN yum install -y autoconf automake gcc-c++ libdb4-cxx libdb4-cxx-devel boost-devel openssl-devel git bzip2 make file sudo patch libevent-devel libseccomp-devel libcap-devel

RUN cd /tmp && \
        wget https://github.com/google/protobuf/releases/download/v2.6.0/protobuf-2.6.0.tar.bz2 && \
        tar xf protobuf-2.6.0.tar.bz2 && \
        cd /tmp/protobuf-2.6.0 && \
        ./configure && \
        make -Wall -Wwrite-strings -Woverloaded-virtual -Wno-sign-compare && \
        make install

RUN echo "/usr/local/lib" >> /etc/ld.so.conf && \
    echo "/usr/lib" >> /etc/ld.so.conf && \
    ldconfig

ENV PKG_CONFIG_PATH /usr/local/lib/pkgconfig:$PKG_CONFIG_PATH

RUN yum install -y qt5-qtbase-devel qt5-qttools-devel qt5-qtwebsockets qrencode-devel

RUN git clone https://github.com/vergecurrency/verge /coin/git

WORKDIR /coin/git

RUN ./autogen.sh && ./configure --with-gui=qt5 && make && mv src/VERGEd /coin/VERGEd

ADD ./conf/VERGE.conf /root/.VERGE/VERGE.conf

WORKDIR /coin
VOLUME ["/coin/home"]

ENV HOME /coin/home

CMD ["/coin/VERGEd"]

# P2P, RPC
EXPOSE 21102 20102
