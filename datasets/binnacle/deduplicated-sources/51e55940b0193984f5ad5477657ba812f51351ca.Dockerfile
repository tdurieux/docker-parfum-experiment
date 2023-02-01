FROM phusion/baseimage:0.9.19

ENV LANG=en_US.UTF-8

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
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    pip3 install gcovr

# installing mongo drivers
RUN \
    echo "Installing mongo-c-driver" && \
    apt-get -qq update && \
    apt-get install -y \
        pkg-config \
        libssl-dev \
        libsasl2-dev \
        wget \
    && \
    wget https://github.com/mongodb/mongo-c-driver/releases/download/1.9.5/mongo-c-driver-1.9.5.tar.gz && \
    tar xzf mongo-c-driver-1.9.5.tar.gz && \
    cd mongo-c-driver-1.9.5 && \
    ./configure --disable-automatic-init-and-cleanup --enable-static && \
    make && \
    make install && \
    cd .. && \
    rm -rf mongo-c-driver-1.9.5 && \
    echo "Installing mongo-cxx-driver" && \
    git clone https://github.com/mongodb/mongo-cxx-driver.git --branch releases/v3.2 --depth 1 && \
    cd mongo-cxx-driver/build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local .. && \
    make EP_mnmlstc_core && \
    make && \
    make install && \
    cd ../.. && \
    rm -rf mongo-cxx-driver
# end

ADD . /usr/local/src/golos

RUN \
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
        -DENABLE_MONGO_PLUGIN=TRUE \
        .. \
    && \
    make -j$(nproc) && \
    make install && \
    rm -rf /usr/local/src/golos

RUN \
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
        /usr/local/include

ADD share/golosd/golosdctl /usr/local/bin/golosdctl
RUN chmod +x /usr/local/bin/golosdctl

RUN useradd -s /bin/bash -m -d /var/lib/golosd golosd

RUN mkdir /var/cache/golosd && \
    chown golosd:golosd -R /var/cache/golosd

# add blockchain cache to image
#ADD $STEEMD_BLOCKCHAIN /var/cache/golosd/blocks.tbz2

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
ADD share/golosd/config/config_mongo.ini /etc/golosd/config.ini
