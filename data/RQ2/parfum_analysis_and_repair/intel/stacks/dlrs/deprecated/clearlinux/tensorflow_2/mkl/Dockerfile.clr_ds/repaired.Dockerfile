#---------------------------------------------------------------------
# DLRS downstream builder
#---------------------------------------------------------------------
ARG clear_ver
FROM clearlinux/stacks-clearlinux:$clear_ver
LABEL maintainer=otc-swstacks@intel.com
ARG NUMACTL_VERSION=2.0.12

# update os and add required bundles
RUN swupd bundle-add devpkg-openmpi devpkg-libX11 git openssh-server c-basic nodejs-basic curl python3-basic devpkg-gperftools \
    && curl -fSsL -O https://github.com/numactl/numactl/releases/download/v${NUMACTL_VERSION}/numactl-${NUMACTL_VERSION}.tar.gz \
    && tar xf numactl-${NUMACTL_VERSION}.tar.gz \
    && cd numactl-${NUMACTL_VERSION} \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make \
    && make install \
    && rm -rf /numactl-${NUMACTL_VERSION}* \
    && rm -rf /var/lib/swupd/* \
    && ln -sf /usr/lib64/libstdc++.so /usr/lib64/libstdc++.so.6 \
    && ln -sf /usr/lib64/libzstd.so.1.4.* /usr/lib64/libzstd.so.1 \
    && ln -s /usr/lib64/libtcmalloc.so /usr/lib/libtcmalloc.so && rm numactl-${NUMACTL_VERSION}.tar.gz
