FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y \
    autoconf \
    automake \
    build-essential \
    cmake \
    curl \
    debhelper \
    git \
    libcurl4-openssl-dev \
    libprotobuf-dev \
    libssl-dev \
    libtool \
    lsb-release \
    ocaml \
    ocamlbuild \
    protobuf-compiler \
    python \
    wget \
    libcurl4 \
    libprotobuf10 \
    libssl1.1 \
    make \
    module-init-tools \
    unzip && rm -rf /var/lib/apt/lists/*;

RUN git clone -b sgx_2.13 --depth 1 https://github.com/intel/linux-sgx

RUN cd linux-sgx && make preparation

WORKDIR /linux-sgx
COPY . .

RUN make sdk_install_pkg_no_mitigation

WORKDIR /opt/intel
RUN sh -c 'echo yes | /linux-sgx/linux/installer/bin/sgx_linux_x64_sdk_*.bin'

WORKDIR /linux-sgx
RUN make psw_install_pkg

WORKDIR /opt/intel
RUN cp /linux-sgx/linux/installer/bin/sgx_linux_x64_psw*.bin .
RUN ./sgx_linux_x64_psw*.bin --no-start-aesm

COPY . /usr/src/sdk
RUN ls /usr/src/sdk/autoconf.bash
WORKDIR /usr/src/sdk

RUN apt update && \
    apt install --no-install-recommends -yq apt-utils && \
    apt install -yq --no-install-recommends python-yaml vim \
        telnet git ca-certificates perl \
        reprepro libboost-all-dev alien uuid-dev libxml2-dev ccache \
        yasm flex bison libprocps-dev ccache texinfo \
        libjsonrpccpp-dev curl libjsonrpccpp-tools && \
    ln -s /usr/bin/ccache /usr/local/bin/clang && \
    ln -s /usr/bin/ccache /usr/local/bin/clang++ && \
    ln -s /usr/bin/ccache /usr/local/bin/gcc && \
    ln -s /usr/bin/ccache /usr/local/bin/g++ && \
    ln -s /usr/bin/ccache /usr/local/bin/cc && \
    ln -s /usr/bin/ccache /usr/local/bin/c++ && rm -rf /var/lib/apt/lists/*;

RUN cd scripts && ./build_deps.py && \
       wget --progress=dot:mega -O - https://github.com/intel/dynamic-application-loader-host-interface/archive/072d233296c15d0dcd1fb4570694d0244729f87b.tar.gz | tar -xz && \
       cd dynamic-application-loader-host-interface-072d233296c15d0dcd1fb4570694d0244729f87b && \
       cmake . -DCMAKE_BUILD_TYPE=Release -DINIT_SYSTEM=SysVinit && \
       make install && \
       cd .. && rm -rf dynamic-application-loader-host-interface-072d233296c15d0dcd1fb4570694d0244729f87b && \
       cd /usr/src/sdk && \
       ./autoconf.bash && \
       ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
       bash -c "make -j$(nproc)"
