FROM ubuntu:18.04

LABEL maintainer="Shirong Hao <shirong@linux.alibaba.com>"

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y wget iptables gnupg libbinutils \
    libseccomp-dev libprotoc-dev binutils-dev autoconf libtool g++ pkg-config \
    protobuf-compiler && rm -rf /var/lib/apt/lists/*;

WORKDIR /root

# install prortobuf-c
RUN wget https://github.com/protobuf-c/protobuf-c/archive/v1.3.1.tar.gz &&\
    tar -zxvf v1.3.1.tar.gz && cd protobuf-c-1.3.1 && ./autogen.sh && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install && rm v1.3.1.tar.gz

# install docker
RUN apt-get install --no-install-recommends -y iptables && \
    wget https://download.docker.com/linux/static/stable/x86_64/docker-18.09.7.tgz && \
    tar -zxvf docker-18.09.7.tgz && mv docker/* /usr/bin && rm -rf docker && rm -f docker-18.09.7.tgz && rm -rf /var/lib/apt/lists/*;

# configure the rune runtime of docker
RUN mkdir -p /etc/docker && \
    echo "{\n\t\"runtimes\": {\n\t\t\"rune\": {\n\t\t\t\"path\": \"/usr/local/bin/rune\",\n\t\t\t\"runtimeArgs\": []\n\t\t}\n\t}\n}" >> /etc/docker/daemon.json

# install sgx
RUN echo "deb [arch=amd64] https://download.01.org/intel-sgx/sgx_repo/ubuntu bionic main" | tee /etc/apt/sources.list.d/intel-sgx.list && wget -qO - https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key | apt-key add -

RUN apt-get update -y && apt-get install --no-install-recommends -y \
    libsgx-dcap-quote-verify libsgx-dcap-default-qpl libsgx-epid && rm -rf /var/lib/apt/lists/*;

WORKDIR /root
