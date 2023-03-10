FROM docker.io/library/fedora:32

RUN dnf -y install dnf-plugins-core && \
    dnf copr enable networkmanager/NetworkManager-1.30 -y && \
    dnf copr enable nmstate/nispor -y && \
    dnf -y install --setopt=install_weak_deps=False \
                   NetworkManager \
                   NetworkManager-ovs \
                   NetworkManager-team \
                   NetworkManager-config-server \
                   openvswitch \
                   python3-openvswitch \
                   systemd-udev \
                   python3-gobject-base \
                   python3-pyyaml \
                   python3-setuptools \
                   python3-pip \
                   python36 \
                   python38 \
                   dnsmasq \
                   git \
                   iproute \
                   python3-coveralls \
                   python3-tox \
                   python3-pytest \
                   python3-pytest-cov \
                   rpm-build \
                   tcpreplay \
                   wpa_supplicant \
                   hostapd \
                   # Below packages for pip (used by tox) to build
                   # python-gobject
                   cairo-devel \
                   cairo-gobject-devel \
                   glib2-devel \
                   gobject-introspection-devel \
                   python3-devel \
                   python3-nispor \
                   dpdk \
                   make && \
                   \
    dnf clean all && \
    systemctl enable openvswitch && \
    sed -i -e 's/^#RateLimitInterval=.*/RateLimitInterval=0/' \
    -e 's/^#RateLimitBurst=.*/RateLimitBurst=0/' \
    /etc/systemd/journald.conf

RUN rpm --verifydb

COPY network_manager_enable_trace.conf \
     /etc/NetworkManager/conf.d/97-trace-logging.conf

VOLUME [ "/sys/fs/cgroup" ]

CMD ["/usr/sbin/init"]