ARG dist=centos
ARG tag=latest
ARG username=acetcom
FROM ${username}/${dist}-${tag}-nextepc-base

MAINTAINER Sukchan Lee <acetcom@gmail.com>

RUN yum -y install \
        cscope \
        vim \
        sudo \
        iputils \
        net-tools

COPY setup.sh /root

ARG username=acetcom
RUN useradd -m --uid=1000 ${username} && \
    echo "${username} ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/${username} && \
    chmod 0440 /etc/sudoers.d/${username}

WORKDIR /home/${username}
