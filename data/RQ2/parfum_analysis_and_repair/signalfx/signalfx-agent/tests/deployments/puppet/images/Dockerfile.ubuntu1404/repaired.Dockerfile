FROM ubuntu:14.04

# See https://github.com/tianon/dockerfiles

RUN rm -f /etc/apt/sources.list.d/ubuntu-esm-infra-trusty.list && \
    apt update && \
    apt install --no-install-recommends -y ca-certificates procps wget apt-transport-https curl gnupg && rm -rf /var/lib/apt/lists/*;

ARG PUPPET_RELEASE=""
RUN wget https://apt.puppetlabs.com/puppet${PUPPET_RELEASE}-release-trusty.deb && \
    dpkg -i puppet${PUPPET_RELEASE}-release-trusty.deb && \
    apt update && \
    apt install --no-install-recommends -y puppet-agent && rm -rf /var/lib/apt/lists/*;

ENV PATH=/opt/puppetlabs/bin:$PATH

RUN rm /usr/sbin/policy-rc.d; \
	rm /sbin/initctl; dpkg-divert --rename --remove /sbin/initctl

RUN /usr/sbin/update-rc.d -f ondemand remove; \
	for f in \
		/etc/init/u*.conf \
		/etc/init/mounted-dev.conf \
		/etc/init/mounted-proc.conf \
		/etc/init/mounted-run.conf \
		/etc/init/mounted-tmp.conf \
		/etc/init/mounted-var.conf \
		/etc/init/hostname.conf \
		/etc/init/networking.conf \
		/etc/init/tty*.conf \
		/etc/init/plymouth*.conf \
		/etc/init/hwclock*.conf \
		/etc/init/module*.conf\
	; do \
		dpkg-divert --local --rename --add "$f"; \
	done; \
	echo '# /lib/init/fstab: cleared out for bare-bones Docker' > /lib/init/fstab

COPY tests/packaging/images/init-fake.conf /etc/init/fake-container-events.conf
COPY deployments/puppet /etc/puppetlabs/code/environments/production/modules/signalfx_agent

CMD ["/sbin/init", "-v"]
