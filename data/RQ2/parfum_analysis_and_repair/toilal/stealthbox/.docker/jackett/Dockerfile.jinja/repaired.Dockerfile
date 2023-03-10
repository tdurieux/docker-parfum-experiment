FROM ubuntu:focal

RUN mkdir -p /app/Jackett && mkdir -p /tmp/Jackett && \
apt-get update && apt-get install --no-install-recommends -y curl && \
 JACKETT_VERSION=$( curl -f -sX GET "https://api.github.com/repos/Jackett/Jackett/releases/latest" | awk '/tag_name/{print $4;exit}' FS='[""]') && \
 curl -f -o /tmp/Jackett/Jackett.tar.gz -L https://github.com/Jackett/Jackett/releases/download/$JACKETT_VERSION/Jackett.Binaries.LinuxAMDx64.tar.gz && \
tar zxf /tmp/Jackett/Jackett.tar.gz -C /app/Jackett --strip-components=1 && rm -rf /tmp/Jackett* && \
apt-get purge -y curl && rm -rf /var/lib/apt/lists/* && rm /tmp/Jackett/Jackett.tar.gz

RUN apt-get update && apt-get install --no-install-recommends -y libicu66 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /config && mkdir -p /data && chown -R nobody:nogroup /app /config /data
USER nobody

VOLUME /config /data

EXPOSE 9117

ENV XDG_CONFIG_HOME="/config"
WORKDIR /app/Jackett

ENTRYPOINT ["/app/Jackett/jackett"]
