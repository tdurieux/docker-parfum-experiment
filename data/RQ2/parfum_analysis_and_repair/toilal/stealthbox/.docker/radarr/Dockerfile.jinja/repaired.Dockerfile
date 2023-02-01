FROM ubuntu:focal

RUN mkdir -p /app/Radarr && mkdir -p /tmp/Radarr && \
apt-get update && apt-get install --no-install-recommends -y curl && \
 curl -f -o /tmp/Radarr/Radarr.tar.gz -L "https://radarr.servarr.com/v1/update/master/updatefile?os=linux&runtime=netcore&arch=x64" && \
tar zxf /tmp/Radarr/Radarr.tar.gz -C /app/Radarr --strip-components=1 && rm -rf /tmp/Radarr* && \
apt-get purge -y curl && rm -rf /var/lib/apt/lists/* && rm /tmp/Radarr/Radarr.tar.gz

RUN apt-get update && apt-get install --no-install-recommends -y libicu66 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /config && mkdir -p /data && chown -R nobody:nogroup /app /config /data
USER nobody

VOLUME /config /data

EXPOSE 8989

ENV XDG_CONFIG_HOME="/config"
WORKDIR /app/Radarr

ENTRYPOINT ["/app/Radarr/Radarr"]
