FROM amazonlinux:2

ENV container docker

RUN yum install -y systemd procps initscripts python3-pip && rm -rf /var/cache/yum
RUN pip3 install --no-cache-dir -U pip==20.3.4

ARG ANSIBLE_VERSION='==2.4.0'
RUN pip3 install --no-cache-dir ansible${ANSIBLE_VERSION}

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i = \
    "systemd-tmpfiles-setup.service" ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;

VOLUME [ "/sys/fs/cgroup" ]

COPY deployments/ansible/* /opt/playbook/
COPY tests/deployments/ansible/images/inventory.ini /opt/playbook/
COPY tests/deployments/ansible/images/playbook.yml /opt/playbook/

CMD ["/usr/sbin/init"]
