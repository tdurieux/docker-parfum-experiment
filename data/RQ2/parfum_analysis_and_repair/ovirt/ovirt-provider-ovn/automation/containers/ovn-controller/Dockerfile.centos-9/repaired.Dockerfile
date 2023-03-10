FROM centos/centos:stream9
LABEL maintainer="amusil@redhat.com" purpose="ovirt_provider_ovn_integ_tests"

# Use legacy cryptopolicy as workaround for https://bugzilla.redhat.com/show_bug.cgi?id=2059101
# until https://pagure.io/copr/copr/issue/2106 is fixed
RUN dnf install -y crypto-policies-scripts crypto-policies \
    && \
    update-crypto-policies --set LEGACY

# The copr plugin is installed by default on el8stream
RUN dnf -y install yum-plugin-copr \
    && \
    dnf copr enable -y ovirt/ovirt-master-snapshot \
    && \
    dnf install -y ovirt-release-master \
    && \
    dnf update -y \
    && \
    # Without it the ovirt-openvswitch fails to install
    # It seems that the el8s container has systemd installed by default
    dnf install -y systemd \
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