FROM registry.svc.ci.openshift.org/ocp/builder:golang-1.12 AS builder
WORKDIR /go/src/github.com/openshift/origin
COPY . .
RUN make build WHAT=" \
    vendor/github.com/openshift/sdn/cmd/openshift-sdn \
    vendor/github.com/openshift/sdn/cmd/sdn-cni-plugin \
    vendor/github.com/containernetworking/plugins/plugins/ipam/host-local \
    vendor/github.com/containernetworking/plugins/plugins/main/loopback \
    "
RUN mkdir -p /tmp/build; \
    cp /go/src/github.com/openshift/origin/_output/local/bin/linux/$(go env GOARCH)/openshift-sdn /tmp/build/openshift-sdn; \
    cp /go/src/github.com/openshift/origin/_output/local/bin/linux/$(go env GOARCH)/sdn-cni-plugin /tmp/build/sdn-cni-plugin; \
    cp /go/src/github.com/openshift/origin/_output/local/bin/linux/$(go env GOARCH)/loopback /tmp/build/loopback; \
    cp /go/src/github.com/openshift/origin/_output/local/bin/linux/$(go env GOARCH)/host-local /tmp/build/host-local

FROM registry.svc.ci.openshift.org/ocp/4.2:base
COPY --from=builder /tmp/build/openshift-sdn /usr/bin/
COPY --from=builder /tmp/build/sdn-cni-plugin /opt/cni/bin/openshift-sdn
COPY --from=builder /tmp/build/loopback /opt/cni/bin/
COPY --from=builder /tmp/build/host-local /opt/cni/bin/

RUN INSTALL_PKGS=" \
      openvswitch2.11 container-selinux socat ethtool nmap-ncat \
      libmnl libnetfilter_conntrack conntrack-tools \
      libnfnetlink iproute bridge-utils procps-ng openssl \
      binutils xz sysvinit-tools dbus nftables \
      " && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    mkdir -p /etc/sysconfig/cni/net.d && \
    yum clean all && rm -rf /var/cache/*

COPY ./images/sdn/scripts/iptables /usr/sbin/
COPY ./images/sdn/scripts/iptables-save /usr/sbin/
COPY ./images/sdn/scripts/iptables-restore /usr/sbin/
COPY ./images/sdn/scripts/ip6tables /usr/sbin/
COPY ./images/sdn/scripts/ip6tables-save /usr/sbin/
COPY ./images/sdn/scripts/ip6tables-restore /usr/sbin/
COPY ./images/sdn/scripts/iptables /usr/sbin/

LABEL io.k8s.display-name="OpenShift SDN" \
      io.k8s.description="This is a component of OpenShift and contains the networking tool stack for the default SDN implementation." \
      io.openshift.tags="openshift,sdn"
ENTRYPOINT [ "/usr/bin/openshift-sdn" ]
