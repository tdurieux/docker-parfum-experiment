FROM centos:7

RUN yum update -y && \
    yum install -y \
			sudo \
			which \
		&& yum clean all && rm -rf /var/cache/yum

RUN useradd -ms /bin/bash user \
		&& echo 'user ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

CMD ["/usr/sbin/init"]
