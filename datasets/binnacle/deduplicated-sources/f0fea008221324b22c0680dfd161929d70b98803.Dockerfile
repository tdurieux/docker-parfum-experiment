FROM centos:7

ENV PYTHONDONTWRITEBYTECODE yes

RUN yum install -y  \
        PyYAML bind-utils \
        openssl \
        numactl-libs \
        firewalld-filesystem \
        libpcap \
        hostname \
        iproute strace socat nc \
        unbound unbound-devel python-openvswitch libreswan && \
        yum clean all

ENV OVS_VERSION=2.11.1
ENV OVS_SUBVERSION=1

RUN rpm -ivh https://github.com/alauda/ovs/releases/download/v${OVS_VERSION}-${OVS_SUBVERSION}/openvswitch-${OVS_VERSION}-${OVS_SUBVERSION}.el7.x86_64.rpm && \
    rpm -ivh https://github.com/alauda/ovs/releases/download/v${OVS_VERSION}-${OVS_SUBVERSION}/openvswitch-ipsec-${OVS_VERSION}-${OVS_SUBVERSION}.el7.x86_64.rpm && \
    rpm -ivh https://github.com/alauda/ovs/releases/download/v${OVS_VERSION}-${OVS_SUBVERSION}/openvswitch-devel-${OVS_VERSION}-${OVS_SUBVERSION}.el7.x86_64.rpm && \
    rpm -ivh https://github.com/alauda/ovs/releases/download/v${OVS_VERSION}-${OVS_SUBVERSION}/ovn-${OVS_VERSION}-${OVS_SUBVERSION}.el7.x86_64.rpm && \
    rpm -ivh https://github.com/alauda/ovs/releases/download/v${OVS_VERSION}-${OVS_SUBVERSION}/ovn-common-${OVS_VERSION}-${OVS_SUBVERSION}.el7.x86_64.rpm && \
    rpm -ivh https://github.com/alauda/ovs/releases/download/v${OVS_VERSION}-${OVS_SUBVERSION}/ovn-vtep-${OVS_VERSION}-${OVS_SUBVERSION}.el7.x86_64.rpm && \
    rpm -ivh https://github.com/alauda/ovs/releases/download/v${OVS_VERSION}-${OVS_SUBVERSION}/ovn-central-${OVS_VERSION}-${OVS_SUBVERSION}.el7.x86_64.rpm && \
    rpm -ivh https://github.com/alauda/ovs/releases/download/v${OVS_VERSION}-${OVS_SUBVERSION}/ovn-host-${OVS_VERSION}-${OVS_SUBVERSION}.el7.x86_64.rpm

RUN mkdir -p /var/run/openvswitch
WORKDIR /kube-ovn

CMD ["sh", "start-controller.sh"]

COPY start-controller.sh /kube-ovn/start-controller.sh
COPY kube-ovn-controller /kube-ovn/kube-ovn-controller
