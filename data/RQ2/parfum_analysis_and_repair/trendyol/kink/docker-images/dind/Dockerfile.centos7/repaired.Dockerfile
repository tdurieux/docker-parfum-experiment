FROM centos:7

MAINTAINER Jie Yu <yujie.jay@gmail.com>

# Install docker, make, git, kubectl, helm
RUN yum update -y && \
    yum install -y \
      yum-utils \
      device-mapper-persistent-data \
      lvm2 \
      git \
      make \
      curl && \
    yum-config-manager \
      --add-repo https://download.docker.com/linux/centos/docker-ce.repo && \
    yum install -y \
      docker-ce \
      docker-ce-cli \
      containerd.io && \
    yum clean all && rm -rf /var/cache/yum

ADD https://github.com/krallin/tini/releases/download/v0.18.0/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

# Set up subuid/subgid so that "--userns-remap=default" works
# out-of-the-box.
RUN set -x && \
    groupadd --system dockremap && \
    adduser --system -g dockremap dockremap && \
    echo 'dockremap:165536:65536' >> /etc/subuid && \
    echo 'dockremap:165536:65536' >> /etc/subgid

VOLUME /var/lib/docker
VOLUME /var/log/docker
EXPOSE 2375 2376
ENV container docker

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]
