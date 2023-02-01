{% set prefix = DEFAULT_CONTAINER_REGISTRY %}
{% if CONFIGURED_ARCH == "armhf" and MULTIARCH_QEMU_ENVIRON == "y" %}
FROM {{ prefix }}multiarch/debian-debootstrap:armhf-stretch
{% elif CONFIGURED_ARCH == "arm64" and MULTIARCH_QEMU_ENVIRON == "y" %}
FROM {{ prefix }}multiarch/debian-debootstrap:arm64-stretch
{% else %}
FROM {{ prefix }}debian:buster
{% endif %}

{% from "dockers/dockerfile-macros.j2" import install_python_wheels, copy_files %}

USER root
WORKDIR /root

MAINTAINER Pavel Shirshov

RUN echo "deb [arch=amd64] http://debian-archive.trafficmanager.net/debian buster-backports main" >> /etc/apt/sources.list
## Make apt-get non-interactive
ENV DEBIAN_FRONTEND=noninteractive

## Set the apt source, update package cache and install necessary packages
## TODO: Clean up this step
RUN sed --in-place 's/httpredir.debian.org/debian-archive.trafficmanager.net/' /etc/apt/sources.list \
    && apt-get update          \
    && apt-get upgrade -y   \
    && apt-get dist-upgrade -y \
    && apt-get install --no-install-recommends -y \
        autoconf \
        openssh-server \
        vim \
        telnet \
        net-tools \
        traceroute \
        lsof \
        tcpdump \
        ethtool \
        unzip \
        pkg-config \
        binutils \
        build-essential \
        libssl-dev \
        libffi-dev \
        wget \
        cmake \
        libqt5core5a \
        libqt5network5 \
        libboost-atomic1.71.0 \
        less \
        git \
        iputils-ping \
        hping3 \
        curl \
        tmux \
        python \
        python-dev \
        python-libpcap \
        python-scapy \
        python-six \
        python3 \
        python3-venv \
        python3-pip \
        python3-dev \
        python3-scapy \
        python3-six \
        libpcap-dev \
        tacacs+ \
        rsyslog \
        ntp \
        ntpstat \
        ntpdate \
        arping \
        bridge-utils \
        libteam-utils \
        gdb \
        automake \
        iproute2 && rm -rf /var/lib/apt/lists/*;

# Install all python modules from pypi. python-scapy is exception, ptf debian package requires python-scapy
# TODO: Clean up this step
RUN rm -rf /debs \
    && apt-get -y autoclean \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/* \
    && wget --https-only https://bootstrap.pypa.io/pip/2.7/get-pip.py \
    && python get-pip.py \
    && rm -f get-pip.py \
    && pip install --no-cache-dir setuptools \
    && pip install --no-cache-dir supervisor \
    && pip install --no-cache-dir ipython==5.4.1 \
    && git clone https://github.com/p4lang/scapy-vxlan.git \
    && cd scapy-vxlan \
    && python setup.py install \
    && cd .. \
    && rm -fr scapy-vxlan \
    && git clone https://github.com/sflow/sflowtool \
    && cd sflowtool \
    && ./boot.sh \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make \
    && make install \
    && cd  .. \
    && rm -fr sflowtool \
    && git clone https://github.com/dyninc/OpenBFDD.git \
    && cd OpenBFDD \
    && ./autogen.sh \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make \
    && make install \
    && cd  .. \
    && rm -fr OpenBFDD \
    && wget https://github.com/nanomsg/nanomsg/archive/1.0.0.tar.gz \
    && tar xvfz 1.0.0.tar.gz \
    && cd nanomsg-1.0.0 \
    && mkdir -p build \
    && cd build \
    && cmake .. \
    && make install \
    && ldconfig \
    && cd ../.. \
    && rm -fr nanomsg-1.0.0 \
    && rm -f 1.0.0.tar.gz \
    && pip install --no-cache-dir cffi \
    && pip install --no-cache-dir nnpy \
    && pip install --no-cache-dir dpkt \
    && pip install --no-cache-dir ipaddress \
    && pip install --no-cache-dir pysubnettree \
    && pip install --no-cache-dir paramiko \
    && pip install --no-cache-dir flask \
    && pip install --no-cache-dir exabgp==3.4.17 \
    && pip install --no-cache-dir pyaml \
    && pip install --no-cache-dir pybrctl pyro4 rpyc yabgp \
    && pip install --no-cache-dir unittest-xml-reporting \
    && pip install --no-cache-dir pyrasite \
    && pip install --no-cache-dir retrying \
    && mkdir -p /opt \
    && cd /opt \
    && wget https://raw.githubusercontent.com/p4lang/ptf/master/ptf_nn/ptf_nn_agent.py

RUN python3 -m venv env-python3

# Activating a virtualenv. The virtualenv automatically works for RUN, ENV and CMD.
ENV VIRTUAL_ENV=/root/env-python3
ARG BACKUP_OF_PATH="$PATH"
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 PYTHONIOENCODING=UTF-8

RUN python3 -m pip install --upgrade --ignore-installed pip

# Install all python modules from pypi. python3-scapy is exception, ptf debian package requires python3-scapy
RUN python3 -m pip install setuptools \
    && pip3 install --no-cache-dir supervisor \
    && pip3 install --no-cache-dir ipython==5.4.1 \
    && pip3 install --no-cache-dir Cython \
    && pip3 install --no-cache-dir cffi \
    && pip3 install --no-cache-dir nnpy \
    && pip3 install --no-cache-dir dpkt \
    && pip3 install --no-cache-dir ipaddress \
    && pip3 install --no-cache-dir pysubnettree \
    && pip3 install --no-cache-dir paramiko \
    && pip3 install --no-cache-dir Flask \
    && pip3 install --no-cache-dir exabgp \
    && pip3 install --no-cache-dir pyaml \
    && pip3 install --no-cache-dir pybrctl pyro4 rpyc yabgp \
    && pip3 install --no-cache-dir unittest-xml-reporting \
    && pip3 install --no-cache-dir pyrasite \
    && pip3 install --no-cache-dir python-libpcap \
    && pip3 install --no-cache-dir enum34 \
    && pip3 install --no-cache-dir grpcio \
    && pip3 install --no-cache-dir grpcio-tools \
    && pip3 install --no-cache-dir protobuf \
    && pip3 install --no-cache-dir six==1.16.0 \
    && pip3 install --no-cache-dir itsdangerous \
    && pip3 install --no-cache-dir retrying \
    && pip3 install --no-cache-dir jinja2 \
    && pip3 install --no-cache-dir scapy==2.4.5

{% if docker_ptf_whls.strip() -%}
# Copy locally-built Python wheel dependencies
{{ copy_files("python-wheels/", docker_ptf_whls.split(' '), "/python-wheels/") }}

# Install locally-built Python wheel dependencies
{{ install_python_wheels(docker_ptf_whls.split(' ')) }}
{% endif %}

# Deactivating a virtualenv.
ENV PATH="$BACKUP_OF_PATH"

## Adjust sshd settings
RUN mkdir /var/run/sshd \
    && echo 'root:root' | chpasswd \
    && sed -ri '/^#?PermitRootLogin/c\PermitRootLogin yes' /etc/ssh/sshd_config \
    && sed -ri '/^#?UsePAM/c\UsePAM no' /etc/ssh/sshd_config \
    && sed -ri '/^#?UseDNS/c\UseDNS no' /etc/ssh/sshd_config

COPY supervisord.conf /etc/supervisor/
COPY conf.d/ /etc/supervisor/conf.d/
COPY ptf_tgen.sh /ptf_tgen/

# Move tcpdump into /usr/bin Otherwise it's impossible to run tcpdump due to a docker bug
RUN mv /usr/sbin/tcpdump /usr/bin/tcpdump
RUN ln -s /usr/bin/tcpdump /usr/sbin/tcpdump

RUN mkdir -p /var/log/supervisor

# Install Python-based GNMI client
RUN git clone https://github.com/lguohan/gnxi.git \
    && cd gnxi \
    && git checkout 53901ab \
    && cd gnmi_cli_py \
    && pip install --no-cache-dir -r requirements.txt

COPY \
{% for deb in docker_ptf_debs.split(' ') -%}
debs/{{ deb }}{{' '}}
{%- endfor -%}
debs/

RUN dpkg -i \
{% for deb in docker_ptf_debs.split(' ') -%}
debs/{{ deb }}{{' '}}
{%- endfor %}

COPY ["*.ini", "/etc/ptf/"]
EXPOSE 22 8009

ENTRYPOINT ["/usr/local/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
