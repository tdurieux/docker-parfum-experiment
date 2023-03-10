FROM centos/centos:stream9
LABEL maintainer="amusil@redhat.com" purpose="ovirt_provider_ovn_tests"

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
    dnf install -y \
        createrepo_c \
        git \
        make \
        ovirt-python-openvswitch \
        python3-devel \
        python3-mock \
        python3-ovsdbapp \
        python3-pip \
        python3-pytest \
        python3-requests \
        python3-requests-mock \
        python3-setuptools \
        python3-six \
        rpm-build \
    && \
    dnf clean all

# Add tox
RUN python3 -m pip install --upgrade pip \
    && \
    python3 -m pip install tox

CMD ["/usr/sbin/init"]