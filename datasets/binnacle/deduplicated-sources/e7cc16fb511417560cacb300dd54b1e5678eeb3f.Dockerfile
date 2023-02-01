FROM fedora:28
RUN dnf install -y http://resources.ovirt.org/pub/yum-repo/ovirt-release-master.rpm && \
  dnf update -y && \
  dnf install -y \
    PyYAML \
    autoconf \
    automake \
    dbus-python \
    dnf-utils \
    dosfstools \
    e2fsprogs \
    gcc \
    gdb \
    genisoimage \
    git \
    glusterfs-api \
    iproute-tc \
    libselinux-python \
    libselinux-python3 \
    lshw \
    make \
    mom \
    openvswitch \
    ovirt-imageio-common \
    psmisc \
    python-blivet1 \
    python-decorator \
    python-devel \
    python-inotify \
    python-ipaddress \
    python-magic \
    python-netaddr \
    python-pip \
    python-pthreading \
    python-requests \
    python-six \
    python-subprocess32 \
    python2-augeas \
    python2-dateutil \
    python2-dmidecode \
    python2-enum34 \
    python2-ioprocess \
    python2-libvirt \
    python2-mock \
    python2-policycoreutils \
    python2-pyudev \
    python3 \
    python3-augeas \
    python3-dateutil \
    python3-dbus \
    python3-decorator \
    python3-devel \
    python3-ioprocess \
    python3-libvirt \
    python3-magic \
    python3-netaddr \
    python3-nose \
    python3-pyudev \
    python3-six \
    python3-yaml \
    redhat-rpm-config \
    rpm-python \
    sanlock-python \
    sudo \
    systemd \
    systemd-udev \
    which \
    && \
  debuginfo-install -y python2 python3 && \
  pip install nose==1.3.7 tox==2.9.1 yappi==0.93 && \
  dnf clean all

COPY lvmlocal.conf /etc/lvm/
