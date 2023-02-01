#
# SSH server for provisioning tests.
#
FROM	ubuntu

RUN apt-get update && apt-get install --no-install-recommends -y \
		openssh-server \
		python-simplejson \
		rsync \
		sudo && rm -rf /var/lib/apt/lists/*;

EXPOSE	22

RUN	mkdir /var/run/sshd \
	&& echo 'root:root' |chpasswd \
	&& sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
	&& sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

CMD    ["/usr/sbin/sshd", "-D"]
