FROM ubuntu:16.04
MAINTAINER Sanjeev Mehrotra <sanjeevm0@hotmail.com>

RUN apt-get update && apt-get install -y --no-install-recommends \
        apt-utils \
        software-properties-common \
        git \
        curl \
        python-pip \
        wget \
        cpio \
        mkisofs \
        apt-transport-https \
	openssh-client \
        ca-certificates && rm -rf /var/lib/apt/lists/*;

# Install docker
RUN curl -fsSL https://yum.dockerproject.org/gpg | apt-key add -
RUN add-apt-repository \
       "deb https://apt.dockerproject.org/repo/ \
       ubuntu-$(lsb_release -cs) \
       main"
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    docker-engine && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir setuptools && pip install --no-cache-dir pyyaml && pip install --no-cache-dir jinja2

RUN echo "dockerd > /dev/null 2>&1 &" | cat >> /etc/bash.bashrc

