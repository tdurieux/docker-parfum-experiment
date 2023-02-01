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

ADD . /usr/local/src/golos

RUN \
    cd /usr/local/src/golos && \
    git submodule deinit -f . && \
    git submodule update --init --recursive -f && \
    mkdir build && \
    cd build && \
    cmake \
        -DCMAKE_BUILD_TYPE=Debug \
        -DBUILD_GOLOS_TESTNET=TRUE \
        -DMAX_19_VOTED_WITNESSES=TRUE \
        -DENABLE_MONGO_PLUGIN=FALSE \
        .. && \
    make -j$(nproc) chain_test plugin_test && \
    ./tests/chain_test --log_level=message --report_level=detailed && \
    ./tests/plugin_test --log_level=message --report_level=detailed

# isn't used now, but can be used later ...
#
# RUN \
#    cd /usr/local/src/golos && \
#    rm -rf build && \
#    git submodule update --init --recursive -f && \
#    mkdir build && \
#    cd build && \
#    cmake \
#        -DCMAKE_BUILD_TYPE=Debug \
#        -DENABLE_COVERAGE_TESTING=TRUE \
#        -DBUILD_GOLOS_TESTNET=TRUE \
#        -DMAX_19_VOTED_WITNESSES=TRUE \
#        -DENABLE_MONGO_PLUGIN=FALSE \
#        .. && \
#    make -j$(nproc) chain_test plugin_test && \
#    ./tests/chain_test && \
#    ./tests/plugin_test && \
#    mkdir -p /var/cobertura && \
#    gcovr --object-directory="../" --root=../ --xml-pretty --gcov-exclude=".*tests.*" --gcov-exclude=".*fc.*"  --output="/var/cobertura/coverage.xml"
