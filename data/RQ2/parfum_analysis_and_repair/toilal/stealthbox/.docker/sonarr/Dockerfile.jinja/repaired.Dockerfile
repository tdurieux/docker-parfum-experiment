FROM ubuntu:focal

RUN apt-get update && apt-get install --no-install-recommends -y mono-devel ca-certificates-mono && rm -rf /var/lib/apt/lists/*

# ENV SONARR_VERSION="2.0.0.5344"
ENV SONARR_BRANCH="master"

RUN mkdir -p /app/Sonarr && mkdir -p /tmp/Sonarr && \
apt-get update && apt-get install --no-install-recommends -y curl jq && \
 if [ -z ${SONARR_VERSION+x} ]; then \
 SONARR_VERSION=$( curl -f -sX GET https://services.sonarr.tv/v1/download/${SONARR_BRANCH} | jq -r '.version') && \
SONARR_LINUX_URL="https://download.sonarr.tv/v2/${SONARR_BRANCH}/mono/NzbDrone.${SONARR_BRANCH}.${SONARR_VERSION}.mono.tar.gz"; \
 else \
 SONARR_LINUX_URL=$( curl -f -sX GET "https://services.sonarr.tv/v1/download/$SONARR_BRANCH" | jq -r .linux.manual.url) ; \
 fi && \
 curl -f -o /tmp/Sonarr/Sonarr.tar.gz -L "$SONARR_LINUX_URL" && \
tar zxf /tmp/Sonarr/Sonarr.tar.gz -C /app/Sonarr --strip-components=1 && rm -rf /tmp/Sonarr* && \
apt-get purge -y curl jq && rm -rf /var/lib/apt/lists/* && rm /tmp/Sonarr/Sonarr.tar.gz

RUN mkdir -p /config && mkdir -p /data && chown -R nobody:nogroup /app /config /data
USER nobody

VOLUME /config /data

EXPOSE 8989

ENV XDG_CONFIG_HOME="/config"
WORKDIR /app/Sonarr

ENTRYPOINT ["mono", "NzbDrone.exe"]
