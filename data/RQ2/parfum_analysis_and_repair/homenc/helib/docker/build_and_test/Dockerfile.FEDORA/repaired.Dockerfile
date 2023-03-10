# Recipe for an HE-ready Fedora 34 docker
FROM fedora:34

# Install general HElib pre-requisites
RUN yum -y upgrade && \
    yum -y update && \
    yum -y group install "Development Tools" && \
    yum -y install g++ m4 patchelf cmake3 wget python3 diffutils parallel && rm -rf /var/cache/yum

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
RUN yum -y install gmp-devel ntl-devel && rm -rf /var/cache/yum

# Script for building and testing HElib
COPY build_scripts/build_and_test_helib.sh /root

# Default script - Build and test HElib and all subprojects using package build
CMD ["/root/build_and_test_helib.sh", "-a"]
