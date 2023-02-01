FROM registry.access.redhat.com/ubi8/ubi-minimal:latest
ENV ROOT=/usr/local
ARG make_args=-j4
RUN microdnf install --disablerepo \*ubi\* --enablerepo codeready-builder-for-rhel-8-x86_64-rpms \
    libtool pkgconfig autoconf automake make cmake file python2-six python3 python3-six \
    openssl-devel git gcc gcc-c++ diffutils python2-devel kernel-headers-4.18.0-147.8.1.el8_1.x86_64 \
    kernel-devel-4.18.0-147.8.1.el8_1.x86_64 kernel-modules-4.18.0-147.8.1.el8_1.x86_64 \
    elfutils-libelf-devel libnetfilter_conntrack-devel wget which curl-devel procps \
    zlib-devel numactl-devel numactl-libs meson ninja-build xz xz-libs net-tools logrotate && microdnf clean all
RUN curl -f -O https://fast.dpdk.org/rel/dpdk-18.11.6.tar.xz \
  && tar -xf dpdk-18.11.6.tar.xz \
  && mkdir -p /usr/src \
  && mv dpdk-stable-18.11.6 /usr/src \
  && export DPDK_DIR=/usr/src/dpdk-stable-18.11.6 \
  && export DPDK_TARGET=x86_64-native-linuxapp-gcc \
  && export DPDK_BUILD=$DPDK_DIR/$DPDK_TARGET \
  && mkdir -p $DPDK_DIR/dpdk-pmds \
  && sed -i 's/CONFIG_RTE_BUILD_SHARED_LIB=n/CONFIG_RTE_BUILD_SHARED_LIB=y/g' $DPDK_DIR/config/common_base \
  && sed -i 's/CONFIG_RTE_EAL_PMD_PATH=\"\"/CONFIG_RTE_EAL_PMD_PATH=\"\/usr\/src\/dpdk-stable-18.11.6\/dpdk-pmds\"/g' $DPDK_DIR/config/common_base \
  && OLD_CWD=`pwd` \
  && cd $DPDK_DIR \
  && make install T=$DPDK_TARGET DESTDIR=/usr/local \
  && cp -r $DPDK_BUILD/lib/*_pmd_* $DPDK_DIR/dpdk-pmds \
  && cp -r $DPDK_BUILD/lib/*_mempool_* $DPDK_DIR/dpdk-pmds \
  && cd $OLD_CWD \
  && ldconfig && rm -rf /usr/src
ENV CFLAGS='-fPIE -D_FORTIFY_SOURCE=2  -g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security'
ENV CXXFLAGS='-fPIE -D_FORTIFY_SOURCE=2  -g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security'
ENV LDFLAGS='-pie -Wl,-z,now -Wl,-z,relro'
RUN git clone https://github.com/openvswitch/ovs.git --branch v2.12.0 --depth 1 \
  && cd ovs \
  && ./boot.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-ssl --disable-libcapng --enable-shared --with-dpdk \
  && make $make_args && make install \
  && mkdir -p $ROOT/include/openvswitch/openvswitch \
  && mv $ROOT/include/openvswitch/*.h $ROOT/include/openvswitch/openvswitch \
  && mv $ROOT/include/openflow $ROOT/include/openvswitch \
  && cp include/*.h "$ROOT/include/openvswitch/" \
  && find lib -name "*.h" -exec cp --parents {} "$ROOT/include/openvswitch/" \; \
  && cd $OLD_CWD \
  && rm -rf ovs && ldconfig
COPY licenses /licenses
COPY launch-ovs-dpdk.sh /usr/local/bin/
CMD ["/usr/local/bin/launch-ovs-dpdk.sh"]
