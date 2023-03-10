FROM ubuntu:focal

RUN apt-get update && apt-get install --no-install-recommends -y mono-devel ca-certificates-mono && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app/Lidarr && mkdir -p /tmp/Lidarr && \
apt-get update && apt-get install --no-install-recommends -y curl jq && \
 LIDARR_TAG_NAME=$( curl -f -sX GET "https://api.github.com/repos/lidarr/Lidarr/releases" | jq -r .[0].tag_name) && \
 LIDARR_VERSION=$( curl -f -sX GET "https://api.github.com/repos/lidarr/Lidarr/releases" | jq -r .[0].name) && \
 curl -f -o /tmp/Lidarr/Lidarr.tar.gz -L https://github.com/lidarr/Lidarr/releases/download/$LIDARR_TAG_NAME/Lidarr.master.$LIDARR_VERSION.linux.tar.gz && \
tar zxf /tmp/Lidarr/Lidarr.tar.gz -C /app/Lidarr --strip-components=1 && rm -rf /tmp/Lidarr* && \
apt-get purge -y curl jq && rm -rf /var/lib/apt/lists/* && rm /tmp/Lidarr/Lidarr.tar.gz

RUN apt-get update && apt-get install --no-install-recommends -y libicu66 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /config && mkdir -p /data && chown -R nobody:nogroup /app /config /data
USER nobody

VOLUME /config /data

EXPOSE 8989

ENV XDG_CONFIG_HOME="/config"
WORKDIR /app/Lidarr

ENTRYPOINT ["mono", "/app/Lidarr/Lidarr.exe"]
