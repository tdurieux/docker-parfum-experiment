FROM quay.io/centos/centos:centos7

RUN yum -y install epel-release && \
    yum -y upgrade && \
    yum -y install NetworkManager NetworkManager-wifi \
    procps-ng iproute ansible openssh-server openssh-clients \
    dnsmasq hostapd wpa_supplicant openssl ethtool iputils && yum clean all && rm -rf /var/cache/yum

VOLUME [ "/sys/fs/cgroup" ]

CMD ["/usr/sbin/init"]
