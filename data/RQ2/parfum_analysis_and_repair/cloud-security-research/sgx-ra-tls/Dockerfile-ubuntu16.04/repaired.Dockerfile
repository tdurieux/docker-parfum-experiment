# Software dependencies to build/run RA-TLS on Ubuntu 16.04.

FROM ubuntu:16.04
# FROM sconecuratedimages/crosscompilers:releasecandidate

# RUN sed -i 's/security\./old-releases\./g' /etc/apt/sources.list && sed -i 's/archive\./old-releases\./g' /etc/apt/sources.list

RUN apt-get update
RUN apt-get install -y --no-install-recommends clang-6.0 coreutils git wget \
    openssh-client build-essential cmake libssl-dev libprotoc-dev \
    protobuf-compiler libprotobuf-dev libprotobuf-c-dev protobuf-c-compiler \
    autoconf libtool ca-certificates automake pkgconf vim-common unzip && rm -rf /var/lib/apt/lists/*;

# Required for apps/redis-secrect-provisioning-example
RUN apt-get install --no-install-recommends -y libnss-myhostname libnss-mdns && rm -rf /var/lib/apt/lists/*;
# Required by package version of redis-server
RUN apt-get install --no-install-recommends -y libjemalloc1 && rm -rf /var/lib/apt/lists/*;

RUN ln -s /usr/bin/clang++-6.0 /usr/bin/clang++ && \
    ln -s /usr/bin/clang-6.0 /usr/bin/clang

# Required for scripts in tests/
RUN apt-get install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;

# Graphene requirements
RUN apt-get install -y --no-install-recommends bison gawk python3 python3-crypto python3-pip \
    python3-setuptools python3-wheel socat && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir protobuf

# SCONE requirements
RUN apt-get install -y --no-install-recommends libprotoc-dev pkgconf protobuf-compiler && rm -rf /var/lib/apt/lists/*; # to compile libprotobuf-c
# SGX-LKL
RUN apt-get install -y --no-install-recommends curl sudo make gcc bc python xutils-dev iproute2 iptables && rm -rf /var/lib/apt/lists/*;

RUN wget https://download.01.org/intel-sgx/dcap-1.0.1/dcap_installer/ubuntuServer1604/libsgx-dcap-ql-dbg_1.0.101.48192-xenial1_amd64.deb \
    https://download.01.org/intel-sgx/dcap-1.0.1/dcap_installer/ubuntuServer1604/libsgx-dcap-ql-dev_1.0.101.48192-xenial1_amd64.deb \
    https://download.01.org/intel-sgx/dcap-1.0.1/dcap_installer/ubuntuServer1604/libsgx-dcap-ql_1.0.101.48192-xenial1_amd64.deb \
    https://download.01.org/intel-sgx/dcap-1.0.1/dcap_installer/ubuntuServer1604/libsgx-enclave-common-dev_2.4.100.48163-xenial1_amd64.deb \
    https://download.01.org/intel-sgx/dcap-1.0.1/dcap_installer/ubuntuServer1604/libsgx-enclave-common_2.4.100.48163-xenial1_amd64.deb \
    https://download.01.org/intel-sgx/dcap-1.0.1/dcap_installer/ubuntuServer1604/sgx_linux_x64_sdk_2.4.100.48163.bin

RUN dpkg -i libsgx-enclave-common_2.4.100.48163-xenial1_amd64.deb
RUN dpkg -i libsgx-enclave-common_2.4.100.48163-xenial1_amd64.deb libsgx-enclave-common-dev_2.4.100.48163-xenial1_amd64.deb
RUN dpkg -i libsgx-dcap-ql_1.0.101.48192-xenial1_amd64.deb
RUN dpkg -i libsgx-dcap-ql-dbg_1.0.101.48192-xenial1_amd64.deb libsgx-dcap-ql-dev_1.0.101.48192-xenial1_amd64.deb
RUN printf 'no\n/opt/intel\n' | bash sgx_linux_x64_sdk_2.4.100.48163.bin

RUN echo 'Defaults env_keep += "http_proxy https_proxy no_proxy"' >> /etc/sudoers
