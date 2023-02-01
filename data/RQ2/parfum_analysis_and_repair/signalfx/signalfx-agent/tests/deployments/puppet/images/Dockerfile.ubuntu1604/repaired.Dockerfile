FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install --no-install-recommends -yq ca-certificates procps systemd wget apt-transport-https curl gnupg && rm -rf /var/lib/apt/lists/*;

ARG PUPPET_RELEASE=""
RUN wget https://apt.puppetlabs.com/puppet${PUPPET_RELEASE}-release-xenial.deb && \
    dpkg -i puppet${PUPPET_RELEASE}-release-xenial.deb && \
    apt-get update && \
    apt-get install --no-install-recommends -y puppet-agent && rm -rf /var/lib/apt/lists/*;

ENV PATH=/opt/puppetlabs/bin:$PATH

ENV container docker
RUN rm -f /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/systemd-update-utmp*

RUN systemctl set-default multi-user.target
ENV init /lib/systemd/systemd

COPY deployments/puppet /etc/puppetlabs/code/environments/production/modules/signalfx_agent

VOLUME [ "/sys/fs/cgroup" ]

ENTRYPOINT ["/lib/systemd/systemd"]
