# A centos8 image with systemd enabled.  Must be run with:
# `--privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro`
# flags
FROM centos:8

ENV container docker

RUN sed -i 's|\$releasever|8-stream|g' /etc/yum.repos.d/CentOS*.repo
RUN dnf install -y --allowerasing centos-stream-release

RUN dnf install -y initscripts

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