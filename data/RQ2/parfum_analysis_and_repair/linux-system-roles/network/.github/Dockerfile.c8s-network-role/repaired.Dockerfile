FROM quay.io/centos/centos:stream8

RUN dnf -y install dnf-plugins-core epel-release && \
    dnf config-manager --set-enabled powertools && \
    dnf -y upgrade && \
    dnf -y install NetworkManager NetworkManager-wifi \
    procps-ng iproute ansible openssh-server openssh-clients systemd-udev \
    dnsmasq hostapd wpa_supplicant openssl ethtool iputils python3-gobject-base

VOLUME [ "/sys/fs/cgroup" ]

CMD ["/usr/sbin/init"]