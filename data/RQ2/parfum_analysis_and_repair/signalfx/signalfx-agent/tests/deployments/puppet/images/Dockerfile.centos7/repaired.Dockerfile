FROM centos:7

ENV container docker

RUN yum install -y systemd procps initscripts && rm -rf /var/cache/yum

ARG PUPPET_RELEASE=""
RUN rpm -Uvh https://yum.puppet.com/puppet${PUPPET_RELEASE}-release-el-7.noarch.rpm && \
    yum install -y puppet-agent && rm -rf /var/cache/yum

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i = \
    "systemd-tmpfiles-setup.service" ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;

VOLUME [ "/sys/fs/cgroup" ]

ENV PATH=/opt/puppetlabs/bin:$PATH

COPY deployments/puppet /etc/puppetlabs/code/environments/production/modules/signalfx_agent

CMD ["/usr/sbin/init"]
