# Software dependencies to build/run RA-TLS on Ubuntu 18.04.

FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y --no-install-recommends gcc-5 libc6-dev g++ make dpkg-dev \
    clang-6.0 coreutils git wget openssh-client cmake libssl-dev \
    libprotoc-dev protobuf-compiler libprotobuf-dev libprotobuf-c-dev \
    protobuf-c-compiler autoconf libtool ca-certificates automake pkgconf \
    unzip rename vim-common && rm -rf /var/lib/apt/lists/*;

RUN ln -s /usr/bin/clang++-6.0 /usr/bin/clang++ && \
    ln -s /usr/bin/clang-6.0 /usr/bin/clang

# Required for apps/redis-secrect-provisioning-example
RUN apt-get install --no-install-recommends -y libnss-myhostname libnss-mdns && rm -rf /var/lib/apt/lists/*;

# Required by package version of redis-server
RUN apt-get install --no-install-recommends -y libjemalloc1 && rm -rf /var/lib/apt/lists/*;

# Graphene requirements
RUN apt-get install -y --no-install-recommends bison gawk python3 python3-protobuf python3-crypto socat && rm -rf /var/lib/apt/lists/*;

# SCONE requirements
RUN apt-get install -y --no-install-recommends libprotoc-dev pkgconf protobuf-compiler && rm -rf /var/lib/apt/lists/*; # to compile libprotobuf-c
# SGX-LKL
RUN apt-get install -y --no-install-recommends curl sudo make gcc bc python xutils-dev iproute2 iptables && rm -rf /var/lib/apt/lists/*;

RUN wget https://download.01.org/intel-sgx/dcap-1.0.1/dcap_installer/ubuntuServer1804/libsgx-dcap-ql-dbg_1.0.101.48192-bionic1_amd64.deb \
    https://download.01.org/intel-sgx/dcap-1.0.1/dcap_installer/ubuntuServer1804/libsgx-dcap-ql-dev_1.0.101.48192-bionic1_amd64.deb \
    https://download.01.org/intel-sgx/dcap-1.0.1/dcap_installer/ubuntuServer1804/libsgx-dcap-ql_1.0.101.48192-bionic1_amd64.deb \
    https://download.01.org/intel-sgx/dcap-1.0.1/dcap_installer/ubuntuServer1804/libsgx-enclave-common-dbgsym_2.4.100.48163-bionic1_amd64.ddeb \
    https://download.01.org/intel-sgx/dcap-1.0.1/dcap_installer/ubuntuServer1804/libsgx-enclave-common-dev_2.4.100.48163-bionic1_amd64.deb \
    https://download.01.org/intel-sgx/dcap-1.0.1/dcap_installer/ubuntuServer1804/libsgx-enclave-common_2.4.100.48163-bionic1_amd64.deb \
    https://download.01.org/intel-sgx/dcap-1.0.1/dcap_installer/ubuntuServer1804/sgx_linux_x64_driver_dcap_4f32b98.bin \
    https://download.01.org/intel-sgx/dcap-1.0.1/dcap_installer/ubuntuServer1804/sgx_linux_x64_sdk_2.4.100.48163.bin

# Works around an issue (https://github.com/intel/linux-sgx/issues/395)
# with installing .deb packages inside Docker
RUN mkdir /etc/init

RUN dpkg -i libsgx-enclave-common_2.4.100.48163-bionic1_amd64.deb
RUN dpkg -i libsgx-enclave-common-dev_2.4.100.48163-bionic1_amd64.deb
RUN dpkg -i libsgx-dcap-ql_1.0.101.48192-bionic1_amd64.deb
RUN dpkg -i libsgx-dcap-ql-dbg_1.0.101.48192-bionic1_amd64.deb libsgx-dcap-ql-dev_1.0.101.48192-bionic1_amd64.deb
RUN printf 'no\n/opt/intel\n' | bash sgx_linux_x64_sdk_2.4.100.48163.bin

RUN echo 'Defaults env_keep += "http_proxy https_proxy no_proxy"' >> /etc/sudoers
