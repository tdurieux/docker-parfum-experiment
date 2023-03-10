FROM centos:8 as dpdk
ENV BUILD_DATE 20201021
ENV RPM_ARCH=x86_64
ENV PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig

ENV DPDK_VERSION=20.11
ENV DPDK_SUBVERSION=1
ENV OVS_VERSION=2.15
ENV OVN_VERSION=20.12

ENV DPDK_DIR=/usr/src/dpdk-${DPDK_VERSION}
ENV OVS_DIR=/usr/src/openvswitch-${OVS_VERSION}
ENV OVN_DIR=/usr/src/ovn

ENV PATH=${PATH}:/usr/share/openvswitch/scripts
ENV PATH=${PATH}:/usr/share/ovn/scripts/

RUN yum -y install dpdk-devel && \
  dnf install -y --enablerepo=powertools \
  gcc make numactl-devel meson \
  unbound nc iptables ipset hostname && \
# Install DPDK
  cd /usr/src/ && \
  curl -f https://fast.dpdk.org/rel/dpdk-${DPDK_VERSION}.tar.gz | tar xz && \
  cd dpdk-${DPDK_VERSION} && \
  meson builddir && cd builddir && \
  meson configure -Dapps='pdump proc-info' -Dexamples='' -Dtests=false -Denable_kmods=false -Denable_docs=false && \
  ninja && ninja install && \
# Clean Up
  dnf remove -y make meson gcc cpp && \
  dnf clean all && rm -rf /var/cache/yum
RUN pkg-config --modversion libdpdk



FROM dpdk as rpm-builder

ENV PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig
RUN dnf install -y --enablerepo=powertools 'dnf-command(builddep)' python3-sphinx groff rpm-build libpcap-devel libibverbs-devel

# Build OVS-DPDK
RUN cd /usr/src/ && \
  curl -f -L https://github.com/openvswitch/ovs/tarball/branch-${OVS_VERSION} > ovs.tar.gz && \
  mkdir ${OVS_DIR} && tar -xf ovs.tar.gz -C ${OVS_DIR} --strip-components 1 && \
  rm -f ovs.tar.gz && cd ${OVS_DIR} && \
  sed -e 's/@VERSION@/0.0.1/' rhel/openvswitch-fedora.spec.in > /tmp/ovs.spec && \
  dnf builddep -y /tmp/ovs.spec && \
  ./boot.sh && \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-dpdk=static && \
  make rpm-fedora RPMBUILD_OPT="--with dpdk --without check"

# Build OVN
RUN cd /usr/src/ && \
  curl -f -L https://github.com/ovn-org/ovn/tarball/branch-${OVN_VERSION} > ovn.tar.gz && \
  mkdir ovn && tar -xf ovn.tar.gz -C ovn --strip-components 1 && \
  rm -f ovn.tar.gz && \
  cd ovn && \
  ./boot.sh && \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-ovs-source=${OVS_DIR} && \
  make rpm-fedora

RUN mkdir -p /rpms && \
  cp ${OVS_DIR}/rpm/rpmbuild/RPMS/${RPM_ARCH}/* ${OVN_DIR}/rpm/rpmbuild/RPMS/${RPM_ARCH}/* /rpms && \
  cd /rpms && rm -f *debug* *docker* *vtep* *ipsec*



FROM dpdk

RUN dnf install -y kmod && dnf clean all
COPY --from=rpm-builder /rpms/* /rpms/
COPY start-ovs-dpdk.sh ovs-dpdk-healthcheck.sh uninstall.sh /kube-ovn/

RUN rpm -ivh --nodeps /rpms/*.rpm && \
  rm -rf ${DPDK_DIR} /rpms && \
  unset DPDK_DIR OVS_DIR OVN_DIR
