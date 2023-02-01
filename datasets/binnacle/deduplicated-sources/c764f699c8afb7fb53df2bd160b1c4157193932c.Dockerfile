FROM phusion/baseimage:0.9.19

ENV LANG=en_US.UTF-8

ADD . /usr/local/src/golos

RUN \
    apt-get update && \
    apt-get install -y \
        autoconf \
        automake \
        autotools-dev \
        bsdmainutils \
        build-essential \
        cmake \
        doxygen \
        git \
        ccache\
        libboost-all-dev \
        libreadline-dev \
        libssl-dev \
        libtool \
        ncurses-dev \
        pbzip2 \
        pkg-config \
        python3 \
        python3-dev \
        python3-pip \
    && \
    pip3 install gcovr && \
    # build golosd
    cd /usr/local/src/golos && \
    git submodule deinit -f . && \
    git submodule update --init --recursive -f && \
    mkdir build && \
    cd build && \
    cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_GOLOS_TESTNET=FALSE \
        -DBUILD_SHARED_LIBRARIES=FALSE \
        -DCHAINBASE_CHECK_LOCKING=FALSE \
        -DENABLE_MONGO_PLUGIN=FALSE \
        .. \
    && \
    make -j$(nproc) && \
    make install && \
    # perform cleanup
    rm -rf /usr/local/src/golos && \
    apt-get remove -y \
        automake \
        autotools-dev \
        bsdmainutils \
        build-essential \
        cmake \
        doxygen \
        dpkg-dev \
        git \
        libboost-all-dev \
        libc6-dev \
        libexpat1-dev \
        libgcc-5-dev \
        libhwloc-dev \
        libibverbs-dev \
        libicu-dev \
        libltdl-dev \
        libncurses5-dev \
        libnuma-dev \
        libopenmpi-dev \
        libpython-dev \
        libpython2.7-dev \
        libreadline-dev \
        libreadline6-dev \
        libssl-dev \
        libstdc++-5-dev \
        libtinfo-dev \
        libtool \
        linux-libc-dev \
        m4 \
        make \
        manpages \
        manpages-dev \
        mpi-default-dev \
        python-dev \
        python2.7-dev \
        python3-dev \
    && \
    apt-get autoremove -y && \
    rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /var/cache/* \
        /usr/include \
        /usr/local/include && \
    # add pseudouser
    useradd -s /bin/bash -m -d /var/lib/golosd golosd && \
    # prepare cache directory
    mkdir /var/cache/golosd && \
    chown golosd:golosd -R /var/cache/golosd

ADD share/golosd/golosdctl /usr/local/bin/golosdctl
RUN chmod +x /usr/local/bin/golosdctl

ENV HOME /var/lib/golosd
RUN chown golosd:golosd -R /var/lib/golosd

ADD share/golosd/snapshot5392323.json /var/lib/golosd

# rpc service:
# http
EXPOSE 8090
# ws
EXPOSE 8091
# p2p service:
EXPOSE 4243

RUN mkdir -p /etc/service/golosd
ADD share/golosd/golosd.sh /etc/service/golosd/run
RUN chmod +x /etc/service/golosd/run

# add seednodes from documentation to image
ADD share/golosd/seednodes /etc/golosd/seednodes

# the following adds lots of logging info to stdout
ADD share/golosd/config/config.ini /etc/golosd/config.ini
