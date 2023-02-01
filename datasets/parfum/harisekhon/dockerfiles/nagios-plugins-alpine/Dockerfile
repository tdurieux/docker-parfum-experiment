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
FROM alpine:3.12

LABEL org.opencontainers.image.description="Advanced Nagios Plugins Collection (Alpine)" \
      org.opencontainers.image.authors="Hari Sekhon (https://www.linkedin.com/in/HariSekhon)" \
      org.opencontainers.image.url="https://ghcr.io/HariSekhon/nagios-plugins" \
      org.opencontainers.image.documentation="https://hub.docker.com/r/harisekhon/nagios-plugins" \
      org.opencontainers.image.source="https://github.com/HariSekhon/Dockerfiles"

COPY build.sh /

RUN apk add --no-cache bash && /build.sh

# Cache Bust upon new commits
ADD https://api.github.com/repos/HariSekhon/Nagios-Plugins/git/refs/heads/master /.git-hashref

# 2nd run is almost a noop without cache, and only an incremental update upon cache bust
RUN /build.sh

#ADD http://date.jsontest.com /etc/builddate
#ADD http://worldclockapi.com/api/json/utc/now /etc/builddate

ENV PATH $PATH:/github/nagios-plugins

WORKDIR /github/nagios-plugins

COPY list_plugins.sh /

CMD ["/list_plugins.sh"]
