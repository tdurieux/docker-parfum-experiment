FROM ubuntu:xenial-20181113

ENV DEBIAN_FRONTEND=noninteractive

RUN set -e -x ; \
    apt-get -y update ; \
    apt-get -y upgrade ; \
    apt-get -y --no-install-recommends install \
        build-essential autoconf cmake clang bison wget flex gperf \
        libreadline-dev gawk tcl-dev libffi-dev graphviz xdot python3-dev \
        libboost-all-dev qt5-default git libftdi-dev pkg-config libeigen3-dev \
        zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN set -e -x ; \
    mkdir -p /usr/local/src ; \
    cd /usr/local/src ; \
    git clone --recursive https://github.com/steveicarus/iverilog.git ; \
    cd iverilog ; \
    git reset --hard 172d7eb0a3665f89b91d601b5912c33acedc81e5 ; \
    sh autoconf.sh ; \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
    make -j $(nproc) ; \
    make install ; \
    rm -rf /usr/local/src/iverilog

RUN set -e -x ;\
    mkdir -p /usr/local/src ;\
    cd /usr/local/src ;\
    git clone --recursive https://github.com/cliffordwolf/icestorm.git ;\
    cd icestorm ;\
    git reset --hard 3a2bfee5cbc0558641668114260d3f644d6b7c83 ;\
    make -j $(nproc) ;\
    make install

RUN set -e -x ;\
    mkdir -p /usr/local/src ;\
    cd /usr/local/src ;\
    git clone --recursive https://github.com/YosysHQ/yosys.git ;\
    cd yosys ;\
    git reset --hard 292f03355a425ede48051c79d5bf619591531080 ;\
    make -j $(nproc) ;\
    make install ;\
    rm -rf /usr/local/src/yosys

RUN set -e -x ;\
    mkdir -p /usr/local/src ;\
    cd /usr/local/src ;\
    git clone --recursive https://github.com/SymbiFlow/prjtrellis.git ;\
    cd prjtrellis ;\
    git reset --hard 668ce3492cbe1566c61760f06bdf676f6fb265c3 ;\
    cd libtrellis ;\
    cmake . ;\
    make -j $(nproc) ;\
    make install
