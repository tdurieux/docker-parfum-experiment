# Recipe for an HE-ready Ubuntu 20.04 docker
FROM ubuntu:20.04

# Install general HElib pre-requisites
RUN apt update && \
    apt dist-upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y build-essential m4 patchelf git libcurl4-openssl-dev zlib1g-dev cmake wget python3 diffutils parallel && rm -rf /var/lib/apt/lists/*;

# Install bats-core (used for testing utils and examples)
RUN cd && \
    wget https://github.com/bats-core/bats-core/archive/v1.2.1.tar.gz && \
    tar xf v1.2.1.tar.gz && \
    cd bats-core-1.2.1 && \
    ./install.sh /usr/local && rm v1.2.1.tar.gz

# Install Google Benchmarks (used for HElib benchmarks)
RUN cd && \
    wget https://github.com/google/benchmark/archive/v1.5.2.tar.gz && \
    tar xf v1.5.2.tar.gz && \
    cd benchmark-1.5.2 && \
    mkdir build && \
    cd build && \
    cmake -DBENCHMARK_ENABLE_GTEST_TESTS=OFF -DCMAKE_BUILD_TYPE=Release .. && \
    make -j4 && \
    make install && rm v1.5.2.tar.gz

# Install NTL and GMP
RUN apt install --no-install-recommends -y libgmp-dev libntl-dev && rm -rf /var/lib/apt/lists/*;

# Script for building and testing HElib
COPY build_scripts/build_and_test_helib.sh /root

# Default script - Build and test HElib and all subprojects using package build
CMD ["/root/build_and_test_helib.sh", "-a"]
