FROM fedora:30

# TODO: add python3-ioprocess.

RUN dnf install -y http://resources.ovirt.org/pub/yum-repo/ovirt-release-master.rpm && \
  dnf update -y && \
  dnf install -y --enablerepo=updates-testing \
    autoconf \
    automake \
    dnf-utils \
    dosfstools \
    e2fsprogs \
    gcc \
    gdb \
    genisoimage \
    git \
    glusterfs-api \
    iproute-tc \
    lshw \
    make \
    mom \
    openvswitch \
    psmisc \
    python3 \
    python3-augeas \
    python3-dateutil \
    python3-dbus \
    python3-decorator \
    python3-devel \
    python3-libselinux \
    python3-libvirt \
    python3-magic \
    python3-netaddr \
    python3-nose \
    python3-pyudev \
    python3-rpm \
    python3-sanlock \
    python3-six \
    python3-yaml \
    redhat-rpm-config \
    sudo \
    systemd \
    systemd-udev \
    which \
    && \
  debuginfo-install -y python3 && \
  python3 -m pip install nose==1.3.7 tox==2.9.1 yappi==0.93 && \
  dnf clean all

COPY lvmlocal.conf /etc/lvm/
