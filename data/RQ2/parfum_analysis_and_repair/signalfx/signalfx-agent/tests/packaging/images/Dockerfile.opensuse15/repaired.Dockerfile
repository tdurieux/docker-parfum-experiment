FROM opensuse/leap:15

ENV container docker

RUN zypper -n install -l curl dbus-1 systemd-sysvinit wget

RUN (cd /usr/lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i = \
    "systemd-tmpfiles-setup.service" ] || rm -f $i; done); \
    rm -f /usr/lib/systemd/system/multi-user.target.wants/*;\
    rm -f /usr/lib/systemd/system/local-fs.target.wants/*; \
    rm -f /usr/lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /usr/lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /usr/lib/systemd/system/basic.target.wants/*;

COPY socat /bin/socat

# Insert our fake certs to the system bundle so they are trusted
COPY certs/*.signalfx.com.* /
RUN cat /*.cert >> /etc/ssl/certs/ca-bundle.crt

VOLUME [ "/sys/fs/cgroup" ]

CMD ["/sbin/init"]