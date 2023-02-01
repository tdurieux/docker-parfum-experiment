# Docker environment for development of DL workspace
FROM ubuntu:18.04
MAINTAINER Jin Li <jinlmsft@hotmail.com>

ENV DEBIAN_FRONTEND=noninteractive

# Software package installation
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
        libcurl4-openssl-dev libssl-dev \
        dirmngr \
        gnupg-agent \
        python3-pip && rm -rf /var/lib/apt/lists/*;

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

RUN add-apt-repository \
   "deb [arch=arm64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

RUN apt-key fingerprint 0EBFCD88

# Install docker
#RUN apt-get update && apt-get install -y --no-install-recommends docker-ce
## if docker daemon version old
RUN apt-get update && apt-get install -y --no-install-recommends docker-ce-cli=5:18.09.0~3-0~ubuntu-bionic && rm -rf /var/lib/apt/lists/*;

# PIP installation
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir setuptools && pip install --no-cache-dir pyyaml jinja2 flask flask.restful tzlocal pycurl requests subprocess32
RUN pip install --no-cache-dir setuptools
RUN pip3 install --no-cache-dir setuptools
RUN sudo apt-get install --no-install-recommends gcc libpq-dev -y && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get install --no-install-recommends python-dev python-pip -y && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get install --no-install-recommends python3-dev python3-pip python3-venv python3-wheel -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir wheel
RUN pip3 install --no-cache-dir pyyaml jinja2 flask flask.restful tzlocal pycurl requests subprocess32

RUN chmod og+rx  -R /usr/local/lib

# RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
#    gpg --dearmor | \
#    sudo tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null

#RUN echo "deb [arch=arm64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | \
#    sudo tee /etc/apt/sources.list.d/azure-cli.list

# RUN apt-get update && apt-get install azure-cli

RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https gnupg2 && rm -rf /var/lib/apt/lists/*;
#RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
#RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list


RUN sudo apt-get update && sudo apt-get install --no-install-recommends -y apt-transport-https curl && rm -rf /var/lib/apt/lists/*;
RUN sudo curl -f https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | sudo apt-key add -
RUN echo 'deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main' >> /etc/apt/sources.list.d/kubernetes.list

RUN apt-get update && apt-get install --no-install-recommends -y kubectl && rm -rf /var/lib/apt/lists/*;
