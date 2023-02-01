FROM amazonlinux:1

RUN yum install -y upstart procps udev initscripts && rm -rf /var/cache/yum

ARG PUPPET_RELEASE=""
RUN rpm -Uvh https://yum.puppet.com/puppet${PUPPET_RELEASE}-release-el-6.noarch.rpm && \
    yum install -y puppet-agent && rm -rf /var/cache/yum

COPY tests/packaging/images/init-fake.conf /etc/init/fake-container-events.conf
COPY deployments/puppet /etc/puppetlabs/code/environments/production/modules/signalfx_agent

ENV PATH=/opt/puppetlabs/bin:$PATH

CMD ["/sbin/init", "-v"]
