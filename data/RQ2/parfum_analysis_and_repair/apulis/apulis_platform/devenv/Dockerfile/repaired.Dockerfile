# Docker environment for development of DL workspace
FROM ubuntu:18.04
MAINTAINER Jin Li <jinlmsft@hotmail.com>

# Software package installation
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
## preesed tzdata, update package index, upgrade packages and install needed software
RUN echo "tzdata tzdata/Areas select Asia" > /tmp/preseed.txt; \
    echo "tzdata tzdata/Zones/Asia select Chongqing" >> /tmp/preseed.txt; \
    debconf-set-selections /tmp/preseed.txt && \
    rm -rf /etc/timezone && \
    rm -rf /etc/localtime && \
    apt-get update && \
    apt-get install --no-install-recommends -y tzdata && rm -rf /var/lib/apt/lists/*;

## cleanup of files from setup
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN apt-get update && apt-get install -y --no-install-recommends \
        apt-utils \
        software-properties-common \
        build-essential \
        cmake \
        git \
        curl \
        wget \
        protobuf-compiler \
        python-dev \
        python-numpy \
        python-pip \
        cpio \
        mkisofs \
        apt-transport-https \
        openssh-client \
        ca-certificates \
        vim \
        sudo \
        git-all \
        sshpass \
        bison \
        libcurl4-openssl-dev libssl-dev && rm -rf /var/lib/apt/lists/*;

RUN apt install --no-install-recommends gpg-agent -y && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
RUN sudo curl -f https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | sudo apt-key add -
RUN echo 'deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main' >> /etc/apt/sources.list.d/kubernetes.list

RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

RUN apt-key fingerprint 0EBFCD88

# Install docker
RUN apt-get update && apt-get install -y --no-install-recommends docker-ce && rm -rf /var/lib/apt/lists/*;

# PIP installation
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir setuptools && pip install --no-cache-dir pyyaml jinja2 flask flask.restful pycurl
RUN pip install --no-cache-dir requests subprocess32 tzlocal pycurl PyYAML
#RUN pip install --upgrade pip install tzlocal

RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https gnupg2 && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get update && sudo apt-get install --no-install-recommends -y apt-transport-https curl && rm -rf /var/lib/apt/lists/*;
RUN sudo curl -f https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | sudo apt-key add -
RUN echo 'deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main' >> /etc/apt/sources.list.d/kubernetes.list

RUN apt-get update && apt-get install --no-install-recommends -y kubectl && rm -rf /var/lib/apt/lists/*;
