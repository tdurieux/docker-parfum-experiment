FROM centos:7

# Update Yum and install epel
RUN yum update -y && \
    yum install -y epel-release && \
    yum groupinstall -y development && rm -rf /var/cache/yum

# Install dependencies
RUN yum install -y \
    git \
    libevent \
    openssl-devel \
    unzip \
    wget \
    httpie \
    net-tools && rm -rf /var/cache/yum

# Install prerequisites for the Couchbase Server python SDK
# https://developer.couchbase.com/documentation/server/current/sdk/python/start-using-sdk.html
RUN wget https://packages.couchbase.com/releases/couchbase-release/couchbase-release-1.0-2-x86_64.rpm; \
    rpm -iv couchbase-release-1.0-2-x86_64.rpm; \
    yum install -y \
        libcouchbase-devel \
        gcc \
        gcc-c++ \
        python-devel \
        python-pip \
        sudo && rm -rf /var/cache/yum

RUN pip install --no-cache-dir --upgrade pip

# Install docker binary for docker in docker
RUN curl -fsSLO https://get.docker.com/builds/Linux/x86_64/docker-17.05.0-ce.tgz && \
    tar --strip-components=1 -xvzf docker-17.05.0-ce.tgz -C /usr/local/bin && rm docker-17.05.0-ce.tgz

WORKDIR /opt

# Git clone mobile-testkit
RUN git clone https://github.com/couchbaselabs/mobile-testkit.git

WORKDIR /opt/mobile-testkit

# Install dependencies
RUN pip install --no-cache-dir --ignore-installed -U ipaddress
RUN pip install --no-cache-dir --ignore-installed -U requests
RUN pip install --no-cache-dir -r requirements.txt

# Create ansible config for sample
RUN cp ansible.cfg.example ansible.cfg

# Set the correct default user
RUN sed -i 's/remote_user = vagrant/remote_user = root/' ansible.cfg

# set python env
ENV PYTHONPATH=/opt/mobile-testkit/
ENV ANSIBLE_CONFIG=/opt/mobile-testkit/ansible.cfg

# Cop test runner script to repo
COPY ./entrypoint.sh /opt/mobile-testkit
CMD ["/bin/bash"]
