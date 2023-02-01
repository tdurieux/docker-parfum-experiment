FROM debian:stretch
MAINTAINER John Morris <john@zultron.com>

# Docker image with ansible and scripts for initializing coreos cluster
# communicating over SSL

RUN apt-get update
RUN apt-get install --no-install-recommends -y \
        python-yaml \
        libyaml-dev \
        python-pip \
        python-dev \
        libffi-dev \
        libssl-dev \
        build-essential \
        python-setuptools \
        python-pkg-resources \
        openssh-client && rm -rf /var/lib/apt/lists/*;

# Digital Ocean
RUN pip install --no-cache-dir python-digitalocean

# paramiko
RUN pip install --no-cache-dir --upgrade \
        cffi pyOpenSSL
RUN pip install --no-cache-dir paramiko

# Ansible
RUN pip install --no-cache-dir \
        Jinja2 \
        ipcalc \
        netaddr \
	jmespath \
        ansible
# dopy > 0.3.5 broken, according to DO Ansible tutorial
RUN pip install --no-cache-dir 'dopy>=0.3.5,<=0.3.5'

# Ansible role to install python on CoreOS
COPY requirements.yaml /etc/ansible/requirements.yaml
RUN mkdir -p /etc/ansible/roles && \
    ansible-galaxy install -r /etc/ansible/requirements.yaml

# Redis (not needed?)
RUN apt-get install --no-install-recommends -y \
    redis-server && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir redis

# Install and configure sudo, passwordless for everyone
RUN apt-get -y --no-install-recommends install sudo && rm -rf /var/lib/apt/lists/*;
RUN echo "ALL	ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

# LDAP python libraries
RUN apt-get -y --no-install-recommends install libldap2-dev libsasl2-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir python-ldap

# For generating vault passwords automatically
RUN apt-get -y --no-install-recommends install apg && rm -rf /var/lib/apt/lists/*;

# Basic tools for command-line use:
# - simple editor
# - telnet, DNS, LDAP clients
# - git
RUN apt-get install --no-install-recommends -y \
        ed \
        telnet \
        dnsutils \
        ldap-utils \
        git \
        psmisc && rm -rf /var/lib/apt/lists/*;

# Install docker for client remote access
# https://docs.docker.com/engine/installation/linux/debian/
RUN apt-get install --no-install-recommends -y \
	apt-transport-https \
	ca-certificates \
	curl \
	gnupg2 \
	software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | \
        apt-key add -
RUN add-apt-repository \
	"deb https://download.docker.com/linux/debian stretch stable"
RUN apt-get update
RUN apt-get install --no-install-recommends -y \
        docker-ce && rm -rf /var/lib/apt/lists/*;

# Python testing (not needed)
RUN pip install --no-cache-dir nose mock

# Add resources in `lib/` to paths
ENV PATH=/data/lib/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV PYTHONPATH=/data/lib/python

# Work around annoying python location on CoreOS
RUN mkdir -p /home/core/bin && ln -s /usr/bin/python /home/core/bin/python

# CoreOS config transpiler
ADD https://github.com/coreos/container-linux-config-transpiler/releases/download/v0.4.0/ct-v0.4.0-x86_64-unknown-linux-gnu \
    /usr/local/bin/ct
RUN chmod 755 /usr/local/bin/ct

# Cloudflare PKI and TLS tool
RUN curl -f -s -L -o /usr/local/bin/cfssl \
        https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 && \
    chmod +x /usr/local/bin/cfssl
RUN curl -f -s -L -o /usr/local/bin/cfssljson \
        https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 && \
    chmod +x /usr/local/bin/cfssljson

# Final container configuration
RUN useradd -s /bin/bash user

VOLUME /data
WORKDIR /data

USER user
