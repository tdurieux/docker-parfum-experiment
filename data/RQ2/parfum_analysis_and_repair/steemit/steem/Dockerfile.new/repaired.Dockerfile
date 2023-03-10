FROM ubuntu:18.04 as builder

# The default build params are for low memory mira version.
# This usually are used as a witness node.
ARG CMAKE_BUILD_TYPE=Release
ARG BUILD_TAG=master
ARG STEEM_STATIC_BUILD=ON
ARG ENABLE_MIRA=ON
ARG LOW_MEMORY_MODE=ON
ARG CLEAR_VOTES=ON
ARG SKIP_BY_TX_ID=ON
ARG BUILD_STEEM_TESTNET=OFF
ARG ENABLE_COVERAGE_TESTING=OFF
ARG CHAINBASE_CHECK_LOCKING=OFF
ARG UNIT_TEST=OFF
ARG DOXYGEN=OFF

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        git \
        build-essential \
        libboost-all-dev \
        cmake \
        libssl-dev \
        libsnappy-dev \
        python3-jinja2 \
        doxygen \
        autoconf \
        automake \
        autotools-dev \
        bsdmainutils \
        libyajl-dev \
        libreadline-dev \
        libssl-dev \
        libtool \
        liblz4-tool \
        ncurses-dev \
        libgflags-dev \
        zlib1g-dev \
        libbz2-dev \
        liblz4-dev \
        libzstd-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/local/src
ADD . /usr/local/src

RUN pwd && \
    git fetch origin ${BUILD_TAG} && \
    git checkout ${BUILD_TAG} && \
    git submodule update --init --recursive

RUN mkdir build && \
    cd build && \
    cmake \
        -DCMAKE_INSTALL_PREFIX=/usr/local/steemd \
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
        -DLOW_MEMORY_NODE=${LOW_MEMORY_MODE} \
        -DCLEAR_VOTES=${CLEAR_VOTES} \
        -DSKIP_BY_TX_ID=${SKIP_BY_TX_ID} \
        -DBUILD_STEEM_TESTNET=${BUILD_STEEM_TESTNET} \
        -DENABLE_COVERAGE_TESTING=${ENABLE_COVERAGE_TESTING} \
        -DCHAINBASE_CHECK_LOCKING=${CHAINBASE_CHECK_LOCKING} \
        -DENABLE_MIRA=${ENABLE_MIRA} \
        -DSTEEM_STATIC_BUILD=${STEEM_STATIC_BUILD} \
        .. && \
    make -j$(nproc) && \
    make install

RUN if [ "${UNIT_TEST}" = "ON" ] ; then \
        cd tests && \
        ctest -j$(nproc) --output-on-failure && \
        ./chain_test -t basic_tests/curation_weight_test && \
        cd .. && \
        ./programs/util/test_fixed_string; \
    fi

RUN if [ "${DOXYGEN}" = "ON" ] ; then \
        doxygen && \
        PYTHONPATH=programs/build_helpers \
        python3 -m steem_build_helpers.check_reflect && \
        programs/build_helpers/get_config_check.sh; \
    fi

FROM ubuntu:18.04 as final

ARG CMAKE_BUILD_TYPE=Release
ARG BUILD_TAG=master
ARG STEEM_STATIC_BUILD=ON
ARG ENABLE_MIRA=ON
ARG LOW_MEMORY_MODE=ON
ARG CLEAR_VOTES=ON
ARG SKIP_BY_TX_ID=ON
ARG BUILD_STEEM_TESTNET=OFF
ARG ENABLE_COVERAGE_TESTING=OFF
ARG CHAINBASE_CHECK_LOCKING=OFF
ARG DOXYGEN=OFF

RUN echo "BUILD_TAG: ${BUILD_TAG}" >> /etc/build_info&& \
    echo "CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}" >> /etc/build_info && \
    echo "STEEM_STATIC_BUILD: ${STEEM_STATIC_BUILD}" >> /etc/build_info && \
    echo "ENABLE_MIRA: ${ENABLE_MIRA}" >> /etc/build_info && \
    echo "LOW_MEMORY_MODE: ${LOW_MEMORY_MODE}" >> /etc/build_info && \
    echo "CLEAR_VOTES: ${CLEAR_VOTES}" >> /etc/build_info && \
    echo "SKIP_BY_TX_ID: ${SKIP_BY_TX_ID}" >> /etc/build_info && \
    echo "BUILD_STEEM_TESTNET: ${BUILD_STEEM_TESTNET}" >> /etc/build_info && \
    echo "ENABLE_COVERAGE_TESTING: ${ENABLE_COVERAGE_TESTING}" >> /etc/build_info && \
    echo "DOXYGEN: ${DOXYGEN}" >> /etc/build_info

COPY --from=builder /usr/local/steemd /usr/local/steemd
WORKDIR /var/steem
VOLUME [ "/var/steem" ]
RUN apt-get update && \
    apt-get install --no-install-recommends -y libsnappy-dev libreadline-dev && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists && rm -rf /var/lib/apt/lists/*;

CMD ["cat", "/etc/build_info"]
