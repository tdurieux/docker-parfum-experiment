FROM amazonlinux:2

ENV container docker

RUN yum install -y systemd procps initscripts python3-pip python3-devel gcc && rm -rf /var/cache/yum

RUN pip3 install --no-cache-dir msgpack==0.6.2 jinja2==3.0.3
RUN pip3 install --no-cache-dir salt==2019.2

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i = \
    "systemd-tmpfiles-setup.service" ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;

COPY deployments/salt/signalfx-agent/ /srv/salt/signalfx-agent/
COPY tests/deployments/salt/images/top.sls /srv/salt/top.sls
COPY tests/deployments/salt/images/top.sls /srv/pillar/top.sls
COPY tests/deployments/salt/images/minion /etc/salt/minion

VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]
