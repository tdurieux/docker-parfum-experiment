FROM amazonlinux:1

ENV container docker

RUN yum install -y upstart procps initscripts python36-pip python36-devel gcc && rm -rf /var/cache/yum

RUN pip-3.6 install msgpack==0.6.2
RUN pip-3.6 install salt==2019.2

COPY deployments/salt/signalfx-agent/ /srv/salt/signalfx-agent/
COPY tests/deployments/salt/images/top.sls /srv/salt/top.sls
COPY tests/deployments/salt/images/top.sls /srv/pillar/top.sls
COPY tests/deployments/salt/images/minion /etc/salt/minion

VOLUME [ "/sys/fs/cgroup" ]
CMD ["/sbin/init"]
