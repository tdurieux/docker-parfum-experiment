ARG IMAGE=registry.access.redhat.com/ubi8:latest
ARG OUTPUT_IMAGE=registry.access.redhat.com/ubi8:latest

FROM $IMAGE as builder

ARG KVER
ENV KVER=$KVER

ARG KERNEL_SOURCE
ENV KERNEL_SOURCE=$KERNEL_SOURCE

ARG DPDK_VERSION
ENV DPDK_VERSION=$DPDK_VERSION

ARG SIGN_DRIVER
ENV SIGN_DRIVER=$SIGN_DRIVER

COPY files/driver ./files/driver
COPY files/kernel ./files/kernel
COPY signing-keys /signing-key/

RUN if [[ "${KERNEL_SOURCE}" == *"file"* ]]; then \
[[ "${KVER}" == *"rt"* ]] && export RT="rt-" || export RT=""; \
rpm -Uvh --nodeps ./files/kernel/kernel-${RT}devel-${KVER}.rpm --force; \
rpm -Uvh --nodeps ./files/kernel/kernel-${RT}core-${KVER}.rpm --force; \
fi

ENV DPDK_DIR /usr/src/dpdk-stable-${DPDK_VERION}
ENV RTE_TARGET=x86_64-native-linuxapp-gcc
ENV RTE_SDK=${DPDK_DIR}
ENV PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig/

# The second yum install is here to overcome versions mismatch between rpms
RUN yum install -y wget python3 \
 make \
 logrotate \
 ethtool \
 patch \
 which \
 iproute \
 libibverbs \
 lua \
 git \
 gcc && \
 yum clean all && rm -rf /var/cache/yum

RUN pip3 install --no-cache-dir meson ninja

RUN cd /usr/src/ && wget https://fast.dpdk.org/rel/dpdk-${DPDK_VERSION}.tar.xz && tar -xpvf dpdk-${DPDK_VERSION}.tar.xz && rm dpdk-${DPDK_VERSION}.tar.xz && \
    cd dpdk-stable-${DPDK_VERSION} && \
    meson build -Denable_kmods=true -Dkernel_dir="/lib/modules/${KVER}" && \
    cd build && \
    ninja && \
    ninja install

RUN if [[ ${SIGN_DRIVER} == "true" ]]; then \
/usr/src/kernels/$KVER/scripts/sign-file sha256 /signing-key/PK.key /signing-key/PK.pem /usr/src/dpdk-stable-${DPDK_VERSION}/build/kernel/linux/kni/rte_kni.ko; \
fi

FROM $OUTPUT_IMAGE

ARG KVER
ENV KERNEL_VERSION=$KVER

ARG DPDK_VERSION
ENV DPDK_VERSION=$DPDK_VERSION

RUN dnf install --setopt=install_weak_deps=False -y kmod

COPY --from=builder /usr/src/dpdk-stable-${DPDK_VERSION}/build/kernel/linux/kni/rte_kni.ko /oot-driver/
COPY files/script/entrypoint.sh /usr/local/bin/
COPY script/load.sh /usr/local/bin/
COPY script/unload.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/load.sh
RUN chmod +x /usr/local/bin/unload.sh

CMD ["/entrypoint.sh"]