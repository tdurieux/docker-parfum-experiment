FROM debian:stretch-slim

RUN apt-get update && \
    apt-get install --no-install-recommends -yq ca-certificates procps systemd wget libcap2-bin apt-transport-https curl gnupg && rm -rf /var/lib/apt/lists/*;

ARG PUPPET_RELEASE=""
RUN wget https://apt.puppetlabs.com/puppet${PUPPET_RELEASE}-release-stretch.deb && \
    dpkg -i puppet${PUPPET_RELEASE}-release-stretch.deb && \
    apt-get update && \
    apt-get install --no-install-recommends -y puppet-agent && rm -rf /var/lib/apt/lists/*;

ENV PATH=/opt/puppetlabs/bin:$PATH

ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i = \   
    "systemd-tmpfiles-setup.service" ] || rm -f $i; done); \                    
    rm -f /lib/systemd/system/multi-user.target.wants/*;\ 
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/anaconda.target.wants/*;

# Keep it from wiping our scratch dir in /tmp/scratch
RUN rm -f /usr/lib/tmpfiles.d/tmp.conf;

RUN systemctl set-default multi-user.target
ENV init /lib/systemd/systemd

COPY deployments/puppet /etc/puppetlabs/code/environments/production/modules/signalfx_agent

VOLUME [ "/sys/fs/cgroup" ]

ENTRYPOINT ["/lib/systemd/systemd"]
