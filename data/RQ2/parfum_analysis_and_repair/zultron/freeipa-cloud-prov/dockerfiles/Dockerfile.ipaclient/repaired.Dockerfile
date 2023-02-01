FROM zultron/docker-freeipa:centos-7-client

# Base packages
RUN yum install -y \
        ipa-admintools \
	which \
	emacs-nox \
	tcpdump \
	openldap-clients \
	bridge-utils \
	psutils \
	net-tools \
	telnet \
	PyYAML \
	python-jinja2 \
	man \
	epel-release && rm -rf /var/cache/yum

# EPEL packages
RUN yum install -y \
     python-pip \
	python2-paramiko \
	certbot && rm -rf /var/cache/yum

# PIP packages
RUN pip install --no-cache-dir \
     python-digitalocean \
	ipcalc

RUN mkdir -p /etc/systemctl-lite-enabled
# Disable non-existant service
RUN rm -f /etc/systemctl-lite-enabled/rhel-domainname.service
# Enable certmonger service
RUN touch /etc/systemctl-lite-enabled/certmonger.service

RUN groupadd -g 500 core
RUN useradd -M -u 500 -g 500 --shell /bin/bash core

VOLUME /home/core
WORKDIR /home/core
