# produces a docker image suitable to build pmacct

FROM centos:8

RUN yum install -y dnf-plugins-core && \
    yum config-manager --set-enabled powertools && \
    yum install -y \
    autoconf \
    automake \
    bash \
    bison \
    cmake \
    epel-release \
    flex \
    gcc \
    gcc-c++ \
    git \
    glibc-devel \
    glibc-headers \
    jansson-devel \
    json-c-devel \
    libcurl-devel \
    libpcap-devel \
    libpq-devel \
    libstdc++-devel \
    libtool \
    make \
    mysql-devel \
    numactl-devel \
    openssl-devel \
    pkgconfig \
    snappy-devel \
    sqlite-devel \
    gnutls-devel \
    sudo \
    wget \
    which \
    zlib-devel && rm -rf /var/cache/yum

COPY ./ci/deps.sh .
RUN ./deps.sh

ENTRYPOINT ["/bin/bash"]
