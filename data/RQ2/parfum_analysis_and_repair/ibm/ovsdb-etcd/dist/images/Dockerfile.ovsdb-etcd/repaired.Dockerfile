FROM fedora:33

# install needed rpms
RUN INSTALL_PKGS=" \
	hostname kubernetes-client tcpdump procps openvswitch-test ovn \
        " && \
	dnf install --best --refresh -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
	dnf clean all && rm -rf /var/cache/dnf/*

COPY pkg/cmd/server/server /root
COPY schemas/ /root/ovsdb-etcd/schemas/

# ovnkube.sh is the entry point. This script examines environment
# variables to direct operation and configure ovn
COPY dist/images/ovnkube.sh /root/
COPY dist/images/ovndb-raft-functions.sh /root

# so we will have etcdctl in the container, if we want to connect to the etcd
COPY dist/images/etcd /usr/local/bin/
COPY dist/images/etcdctl /usr/local/bin/
RUN mkdir -p /var/run/openvswitch

WORKDIR /root