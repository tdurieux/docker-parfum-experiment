# This can be used to build images for testing
FROM fedora:36 AS builder

RUN INSTALL_PKGS=" \
      golang git \
      " && \
    yum install -y --setopt=tsflags=nodocs --setopt=skip_missing_names_on_install=False $INSTALL_PKGS && rm -rf /var/cache/yum

WORKDIR /go/src/github.com/openshift/sdn
COPY . .
RUN make build --warn-undefined-variables
RUN CGO_ENABLED=0 GO_BUILD_FLAGS="-tags no_openssl -mod=vendor" make build GO_BUILD_PACKAGES="github.com/openshift/sdn/cmd/openshift-sdn-cni" --warn-undefined-variables

FROM fedora:36
COPY --from=builder /go/src/github.com/openshift/sdn/openshift-sdn-node /usr/bin/
COPY --from=builder /go/src/github.com/openshift/sdn/openshift-sdn-controller /usr/bin/
COPY --from=builder /go/src/github.com/openshift/sdn/openshift-sdn-cni /opt/cni/bin/openshift-sdn
COPY --from=builder /go/src/github.com/openshift/sdn/host-local /usr/bin/cni/osdn-host-local

RUN INSTALL_PKGS=" \
      openvswitch container-selinux socat ethtool nmap-ncat \
      libmnl libnetfilter_conntrack conntrack-tools \
      libnfnetlink iproute procps-ng openssl \
      iputils binutils xz util-linux dbus nftables \
      tcpdump gdb" && \
    yum install -y --setopt=tsflags=nodocs --setopt=skip_missing_names_on_install=False $INSTALL_PKGS && \
    mkdir -p /etc/sysconfig/cni/net.d && \
    yum clean all && rm -rf /var/cache/* && rm -rf /var/cache/yum

COPY ./images/iptables-scripts/iptables /usr/sbin/
COPY ./images/iptables-scripts/iptables-save /usr/sbin/
COPY ./images/iptables-scripts/iptables-restore /usr/sbin/
COPY ./images/iptables-scripts/ip6tables /usr/sbin/
COPY ./images/iptables-scripts/ip6tables-save /usr/sbin/
COPY ./images/iptables-scripts/ip6tables-restore /usr/sbin/

LABEL io.k8s.display-name="OpenShift SDN" \
      io.k8s.description="This is a component of OpenShift and contains the default SDN implementation." \
      io.openshift.tags="openshift,sdn,sdn-controller"
