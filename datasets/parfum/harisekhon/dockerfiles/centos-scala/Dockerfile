#
#  Author: Hari Sekhon
#  Date: 2016-01-16 09:58:07 +0000 (Sat, 16 Jan 2016)
#
#  vim:ts=4:sts=4:sw=4:et
#
#  https://github.com/HariSekhon/Dockerfiles
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help improve or steer this or other code I publish
#
#  https://www.linkedin.com/in/HariSekhon
#

# nosemgrep: dockerfile.audit.dockerfile-source-not-pinned.dockerfile-source-not-pinned
FROM harisekhon/centos-java:jdk8

LABEL org.opencontainers.image.description="Scala + CentOS (OpenJDK)" \
      org.opencontainers.image.authors="Hari Sekhon (https://www.linkedin.com/in/HariSekhon)" \
      org.opencontainers.image.url="https://ghcr.io/HariSekhon/centos-scala" \
      org.opencontainers.image.documentation="https://hub.docker.com/r/harisekhon/centos-scala" \
      org.opencontainers.image.source="https://github.com/HariSekhon/Dockerfiles"

ARG SCALA_VERSION=2.10.6

LABEL Description="Scala + CentOS (+OpenJDK)"

RUN set -eux && \
    sed -i "s/^[[:space:]]*mirrorlist/#mirrorlist/" /etc/yum.repos.d/CentOS-* && \
    sed -i "s|^#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|" /etc/yum.repos.d/CentOS-* && \
    rpm -ivh http://downloads.lightbend.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.rpm && \
    yum autoremove -y && \
    yum clean all && \
    rm -rf /var/cache/yum

CMD ["/bin/bash"]
