ARG ASSISTED_INSTALLER_AGENT=quay.io/edge-infrastructure/assisted-installer-agent:latest
FROM $ASSISTED_INSTALLER_AGENT

RUN yum install -y yum-utils \
    && yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo \
    && dnf install -y --nobest --allowerasing \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    tcpdump \
    procps \
    python39 \
    && dnf clean all && rm -rf /var/cache/yum

RUN echo -e "#!/bin/sh \nshift 7 && \$@" > /usr/bin/nsenter && chmod a+x /usr/bin/nsenter
ADD podman_override /usr/bin/podman