FROM centos/centos:stream8
LABEL maintainer="amusil@redhat.com" purpose="ovirt_provider_ovn_tests"

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