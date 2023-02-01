FROM centos:7
RUN yum install -y http://resources.ovirt.org/pub/yum-repo/ovirt-release-master.rpm && \
  yum update -y && \
  yum install -y \
    PyYAML \
    autoconf \
    automake \
    dbus-python \
    dosfstools \
    e2fsprogs \
    gcc \
    gdb \
    genisoimage \
    git \
    glusterfs-api \
    libselinux-python \
    libvirt-python \
    lshw \
    make \
    mom \
    openvswitch \
    ovirt-imageio-common \
    policycoreutils-python \
    psmisc \
    python-augeas \
    python-blivet \
    python-dateutil \
    python-decorator \
    python-devel \
    python-dmidecode \
    python-enum34 \
    python-inotify \
    python-ioprocess \
    python-ipaddress \
    python-magic \
    python-netaddr \
    python-pthreading \
    python-pyudev \
    python-requests \
    python-setuptools \
    python-six \
    python-subprocess32 \
    redhat-rpm-config \
    rpm-python \
    sanlock-python \
    sudo \
    which \
    && \
  debuginfo-install -y python && \
  easy_install pip && \
  pip install nose==1.3.7 tox==2.9.1 yappi==0.93 mock && \
  yum clean all

COPY lvmlocal.conf /etc/lvm/
