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
FROM debian:11

LABEL org.opencontainers.image.description="Bash Tools" \
      org.opencontainers.image.authors="Hari Sekhon (https://www.linkedin.com/in/HariSekhon)" \
      org.opencontainers.image.url="https://ghcr.io/HariSekhon/bash-tools" \
      org.opencontainers.image.documentation="https://hub.docker.com/r/harisekhon/bash-tools" \
      org.opencontainers.image.source="https://github.com/HariSekhon/Dockerfiles"

# used by build.sh to figure out which repo to bootstrap
ENV PATH $PATH:/github/bash-tools

ADD https://raw.githubusercontent.com/HariSekhon/DevOps-Bash-tools/master/setup/docker_bootstrap.sh /build.sh

RUN chmod +x /build.sh && NO_TESTS=1 /build.sh

# Cache Bust upon new commits
ADD https://api.github.com/repos/HariSekhon/DevOps-Bash-tools/git/refs/heads/master /.git-hashref

ADD https://raw.githubusercontent.com/HariSekhon/Dockerfiles/master/src/list_shell.sh /list.sh

# 2nd run is almost a noop without cache, and only an incremental update upon cache bust
RUN chmod +x /list.sh && /build.sh

WORKDIR /github/bash-tools

CMD ["/list.sh", "/github/bash-tools"]
