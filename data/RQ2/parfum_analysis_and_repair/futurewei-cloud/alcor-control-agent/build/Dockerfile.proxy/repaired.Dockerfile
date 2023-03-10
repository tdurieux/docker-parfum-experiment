# MIT License
# Copyright(c) 2020 Futurewei Cloud
#
#     Permission is hereby granted,
#     free of charge, to any person obtaining a copy of this software and associated documentation files(the "Software"), to deal in the Software without restriction,
#     including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and / or sell copies of the Software, and to permit persons
#     to whom the Software is furnished to do so, subject to the following conditions:
#
#     The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
#     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
#     WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

FROM ubuntu:18.04
RUN echo "--- installing mizar dependencies ---" && \
    apt-get update -y && apt-get install --no-install-recommends -y \
    rpcbind \
    rsyslog \
    build-essential \
    clang-9 \
    llvm-9 \
    libelf-dev \
    openvswitch-switch \
    iproute2 \
    net-tools \
    iputils-ping \
    ethtool \
    curl \
    python3 \
    python3-pip \
    netcat \
    libcmocka-dev \
    lcov && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir httpserver netaddr

RUN echo "--- installing grpc dependencies ---" && \
    apt-get install --no-install-recommends -y \
    cmake libssl-dev \
    autoconf git pkg-config \
    automake libtool make g++ unzip && rm -rf /var/lib/apt/lists/*;

RUN echo "--- installing git dependencies ---" && \
    apt-get remove -y git && \
    apt-get install --no-install-recommends -y gettext && \
    apt-get remove -y libcurl4-gnutls-dev && \
    apt-get install --no-install-recommends -y libcurl4-openssl-dev && \
    apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

RUN echo "--- installing git --- " &&  \
    mkdir -p /var/local/git-build && \
    cd /var/local/git-build && \
    wget --no-check-certificate https://github.com/git/git/archive/v2.17.1.tar.gz && \
    tar zxvf v2.17.1.tar.gz && \
    cd git-2.17.1 && \
    make configure && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local --with-openssl --with-curl && \
    make && \
    make install && \
    echo "--- trust gitlab certificate ---" && \
    git config --global http.sslverify false && \
    rm -rf /var/local/git-build && rm v2.17.1.tar.gz

# installing grpc and its dependencies
ENV GRPC_RELEASE_TAG v1.24.x
RUN echo "--- cloning grpc repo ---" && \
    git clone -b ${GRPC_RELEASE_TAG} https://github.com/grpc/grpc /var/local/git/grpc && \
    cd /var/local/git/grpc && \
    git submodule update --init && \
    echo "--- installing c-ares ---" && \
    cd /var/local/git/grpc/third_party/cares/cares && \
    git fetch origin && \
    git checkout cares-1_15_0 && \
    mkdir -p cmake/build && \
    cd cmake/build && \
    cmake -DCMAKE_BUILD_TYPE=Release ../.. && \
    make -j4 install && \
    cd ../../../../.. && \
    rm -rf third_party/cares/cares && \
    echo "--- installing protobuf ---" && \
    cd /var/local/git/grpc/third_party/protobuf && \
    mkdir -p cmake/build && \
    cd cmake/build && \
    cmake -Dprotobuf_BUILD_TESTS=OFF -DCMAKE_BUILD_TYPE=Release .. && \
    make -j4 install && \
    cd ../../../.. && \
    rm -rf third_party/protobuf && \
    echo "--- installing grpc ---" && \
    cd /var/local/git/grpc && \
    mkdir -p cmake/build && \
    cd cmake/build && \
    cmake -DgRPC_INSTALL=ON -DgRPC_BUILD_TESTS=OFF -DgRPC_PROTOBUF_PROVIDER=package -DgRPC_ZLIB_PROVIDER=package -DgRPC_CARES_PROVIDER=package -DgRPC_SSL_PROVIDER=package -DCMAKE_BUILD_TYPE=Release ../.. && \
    make -j4 install && \
    echo "--- installing google test ---" && \
    cd /var/local/git/grpc/third_party/googletest && \
    cmake -Dgtest_build_samples=ON -DBUILD_SHARED_LIBS=ON . && \
    make && \
    make install && \
    rm -rf /var/local/git/grpc

# this layer is consuming about 406MB, can try to optimize
RUN echo "--- installing librdkafka ---" && \
    apt-get install -y --no-install-recommends\
    librdkafka-dev \
    doxygen \
    libssl-dev \
    zlib1g-dev \
    libboost-program-options-dev \
    libboost-all-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN echo "--- installing cppkafka ---" && \
    git clone https://github.com/mfontanini/cppkafka.git /var/local/git/cppkafka && \
    cd /var/local/git/cppkafka && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install && \
    ldconfig && \
    rm -rf /var/local/git/cppkafka

ENV PULSAR_RELEASE_TAG='pulsar-2.6.1'
RUN echo "7--- installing pulsar dependacies ---" && \
    mkdir -p /var/local/git/pulsar && \
    wget https://archive.apache.org/dist/pulsar/${PULSAR_RELEASE_TAG}/DEB/apache-pulsar-client.deb -O /var/local/git/pulsar/apache-pulsar-client.deb && \
    wget https://archive.apache.org/dist/pulsar/${PULSAR_RELEASE_TAG}/DEB/apache-pulsar-client-dev.deb -O /var/local/git/pulsar/apache-pulsar-client-dev.deb && \
    cd /var/local/git/pulsar && \
    apt install --no-install-recommends -y ./apache-pulsar-client*.deb && \
    rm -rf /var/local/git/pulsar && rm -rf /var/lib/apt/lists/*;