FROM ubuntu:22.04 as ovs-builder

ARG ARCH
ARG DEBIAN_FRONTEND=noninteractive
ENV SRC_DIR='/usr/src'

RUN apt update && apt install --no-install-recommends build-essential git libnuma-dev autoconf curl \
    python3 libmnl-dev libpcap-dev libtool libcap-ng-dev libssl-dev pkg-config \
    python3-six libunbound-dev libunwind-dev dh-make fakeroot debhelper dh-python \
    flake8 python3-sphinx graphviz groff wget libjemalloc-dev python3-pip -y && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir meson ninja

RUN cd /usr/src/ && \
    wget https://fast.dpdk.org/rel/dpdk-20.11.1.tar.xz && \
    tar xf dpdk-20.11.1.tar.xz && \
    export DPDK_DIR=/usr/src/dpdk-stable-20.11.1 && \
    export DPDK_BUILD=$DPDK_DIR/build && \
    cd $DPDK_DIR && \
    meson build && \
    ninja -C build && \
    ninja -C build install && \
    ldconfig && rm dpdk-20.11.1.tar.xz


RUN cd /usr/src/ && \
    git clone -b branch-2.16 --depth=1 https://github.com/openvswitch/ovs.git && \
    cd ovs && \
    curl -f -s https://github.com/kubeovn/ovs/commit/22ea22c40b46ee5adeae977ff6cfca81b3ff25d7.patch | git apply && \
    ./boot.sh && \
    rm -rf .git && \
    export DPDK_DIR=/usr/src/dpdk-stable-20.11.1 && \
    CONFIGURE_OPTS='LIBS=-ljemalloc' && \
    if [ "$ARCH" = "amd64" ]; then CONFIGURE_OPTS='LIBS=-ljemalloc CFLAGS="-O2 -g -msse4.2 -mpopcnt"'; fi && \
    DATAPATH_CONFIGURE_OPTS='--prefix=/usr  --with-dpdk=static' EXTRA_CONFIGURE_OPTS=$CONFIGURE_OPTS DEB_BUILD_OPTIONS='parallel=8 nocheck' fakeroot debian/rules binary

RUN dpkg -i /usr/src/python3-openvswitch*.deb /usr/src/libopenvswitch*.deb

RUN cd /usr/src/ && git clone -b branch-21.06 --depth=1 https://github.com/ovn-org/ovn.git && \
    cd ovn && \
    curl -f -s https://github.com/kubeovn/ovn/commit/e24734913d25c0bffdf1cfd79e14ef43d01e1019.patch | git apply && \
    curl -f -s https://github.com/kubeovn/ovn/commit/8f4e4868377afb5e980856755b9f6394f8b649e2.patch | git apply && \
    curl -f -s https://github.com/kubeovn/ovn/commit/23a87cabb76fbdce5092a6b3d3b56f3fa8dd61f5.patch | git apply && \
    curl -f -s https://github.com/kubeovn/ovn/commit/89ca60989df4af9a96cc6024e04f99b9b77bad22.patch | git apply && \
    curl -f -s https://github.com/kubeovn/ovn/commit/aeafa43fc51be8ea1c7abfbe779c69205c1c5aa4.patch | git apply && \
    curl -f -s https://github.com/kubeovn/ovn/commit/71f831b9cc5a6dc923af4ca90286857e2cf8b1d3.patch | git apply && \
    sed -i 's/OVN/ovn/g' debian/changelog && \
    rm -rf .git && \
    ./boot.sh && \
    CONFIGURE_OPTS='LIBS=-ljemalloc' && \
    if [ "$ARCH" = "amd64" ]; then CONFIGURE_OPTS='LIBS=-ljemalloc CFLAGS="-O2 -g -msse4.2 -mpopcnt"'; fi && \
    OVSDIR=/usr/src/ovs EXTRA_CONFIGURE_OPTS=$CONFIGURE_OPTS DEB_BUILD_OPTIONS='parallel=8 nocheck' fakeroot debian/rules binary

RUN mkdir /packages/ && \
     cp /usr/src/libopenvswitch*.deb /packages && \
     cp /usr/src/openvswitch-*.deb /packages && \
     cp /usr/src/python3-openvswitch*.deb /packages && \
     cp /usr/src/ovn-*.deb /packages && \
     cd /packages && rm -f *dbg* *datapath* *docker* *vtep* *ipsec* *test* *dev*

FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt upgrade -y && apt install ca-certificates python3 hostname libunwind8 netbase \
        ethtool iproute2 ncat libunbound-dev procps libatomic1 kmod iptables \
        tcpdump ipset curl uuid-runtime openssl inetutils-ping arping ndisc6 \
        logrotate libjemalloc2 dnsutils  libnuma-dev -y --no-install-recommends && \
        rm -rf /var/lib/apt/lists/* && \
        cd /usr/sbin && \
        ln -sf /usr/sbin/iptables-legacy iptables && \
        ln -sf /usr/sbin/ip6tables-legacy ip6tables && \
        rm -rf /etc/localtime

RUN mkdir -p /var/run/openvswitch && \
    mkdir -p /var/run/ovn && \
    mkdir -p /etc/cni/net.d && \
    mkdir -p /opt/cni/bin

ARG ARCH
ENV CNI_VERSION=v1.0.1
RUN curl -sSf -L --retry 5 https://github.com/containernetworking/plugins/releases/download/${CNI_VERSION}/cni-plugins-linux-${ARCH}-${CNI_VERSION}.tgz | tar -xz -C . ./loopback ./portmap ./macvlan

RUN --mount=type=bind,target=/packages,from=ovs-builder,source=/packages  \
    dpkg -i /packages/libopenvswitch*.deb && \
    dpkg -i /packages/openvswitch-*.deb && \
    dpkg -i /packages/python3-openvswitch*.deb &&\
    dpkg -i --ignore-depends=openvswitch-switch,openvswitch-common /packages/ovn-*.deb
