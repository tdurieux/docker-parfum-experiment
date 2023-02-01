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

# can't base off official Riak as it's missing deps to run the tools
#FROM riak
# nosemgrep: dockerfile.audit.dockerfile-source-not-pinned.dockerfile-source-not-pinned
FROM centos:8

ARG RIAK_VERSION=2.1.4

LABEL org.opencontainers.image.description="Riak" \
      org.opencontainers.image.version="$RIAK_VERSION" \
      org.opencontainers.image.authors="Hari Sekhon (https://www.linkedin.com/in/HariSekhon)" \
      org.opencontainers.image.url="https://ghcr.io/HariSekhon/riak" \
      org.opencontainers.image.documentation="https://hub.docker.com/r/harisekhon/riak" \
      org.opencontainers.image.source="https://github.com/HariSekhon/Dockerfiles"

#RUN OS=el DIST=6 curl "https://packagecloud.io/install/repositories/basho/riak/config_file.repo?os=${OS}&dist=${DIST}&name=basho_repo" > /etc/yum.repos.d/basho.repo && \

# Riak 1.x
#RUN set -euxo pipefail && \
#    yum install -y http://yum.basho.com/gpg/basho-release-6-1.noarch.rpm && \
#    yum install -y riak-$RIAK_VERSION && \
#    yum autoremove -y && \
#    yum clean all
# Riak 2.x