FROM amazonlinux:2

ENV container docker

RUN yum install -y systemd procps initscripts && rm -rf /var/cache/yum

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i = \
    "systemd-tmpfiles-setup.service" ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;

COPY socat /bin/socat

# Insert our fake certs to the system bundle so they are trusted
COPY certs/*.signalfx.com.* /
RUN cat /*.cert >> /etc/pki/tls/certs/ca-bundle.crt

VOLUME [ "/sys/fs/cgroup" ]

CMD ["/usr/sbin/init"]
