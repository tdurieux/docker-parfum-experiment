FROM vpp-container-fun/base
MAINTAINER mestery@mestery.com

ARG STRONGSWAN_REPO_URL
ARG STRONGSWAN_COMMIT

RUN yum -y install epel-release socat iperf tcpdump gmp-devel gperftools-devel gperftools-libs gperftools gperf && \
    yum -y group install "Development Tools" && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    git clone ${STRONGSWAN_REPO_URL} && \
    cd strongswan && \
    git fetch && \
    git checkout ${STRONGSWAN_COMMIT} && \
    ./autogen.sh && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-libipsec --enable-socket-vpp --enable-kernel-vpp && \
    make && \
    make install
