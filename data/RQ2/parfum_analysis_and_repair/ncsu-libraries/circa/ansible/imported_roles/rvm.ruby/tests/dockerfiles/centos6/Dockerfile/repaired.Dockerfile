FROM centos:6

RUN yum update -y && \
		yum install -y \
			initscripts \
			sudo \
		&& yum clean all && rm -rf /var/cache/yum

RUN useradd -ms /bin/bash user \
		&& echo 'user ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

CMD ["/sbin/init"]
