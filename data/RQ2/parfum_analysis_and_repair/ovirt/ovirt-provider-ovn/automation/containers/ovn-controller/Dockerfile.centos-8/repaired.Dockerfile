FROM centos/centos:stream8
LABEL maintainer="amusil@redhat.com" purpose="ovirt_provider_ovn_integ_tests"

# Workaround for https://bugzilla.redhat.com/2024629
RUN rpm --import \
        https://download.copr.fedorainfracloud.org/results/ovirt/ovirt-master-snapshot/pubkey.gpg \
    && \
    dnf --repofrompath=ovirt-master-snapshot,https://download.copr.fedorainfracloud.org/results/ovirt/ovirt-master-snapshot/centos-stream-8-x86_64/ \
        install -y ovirt-release-master \
    && \
    dnf update -y \
    && \
    dnf install -y \
        dhclient \
        iputils \
        NetworkManager-config-server \
        ovirt-openvswitch \
        ovirt-openvswitch-ovn-common \
        ovirt-openvswitch-ovn-host \
        ovirt-python-openvswitch \
    && \
    dnf clean all

COPY ovn-controller.conf /etc/sysconfig/ovn-controller

COPY boot-controller.sh /boot-controller.sh

CMD ["/usr/sbin/init"]