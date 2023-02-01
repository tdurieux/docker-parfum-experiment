FROM ubuntu:16.04

ARG S6_OVERLAY_VERSION=v1.17.2.0
ARG DEBIAN_FRONTEND="noninteractive"
ENV TERM="xterm" LANG="C.UTF-8" LC_ALL="C.UTF-8"

ENTRYPOINT ["/init"]

RUN \

    apt-get update && \
    apt-get install --no-install-recommends -y \
      tzdata \
      curl \
      xmlstarlet \
      uuid-runtime \
    && \
   
tch -f nd ex ra t S6 overlay \
    curl -J -L -o /tmp/s6-overlay-amd64.tar.g  h \
        tar xzf /tmp/s6-overlay-amd64.tar.gz -C / && \

d user \
        useradd -U -d /config -s /bin/false plex && \
    usermod -G users plex && \

# Setup directories
    mkdir - \
       
            /transcode \
      /data \
    && \
   
eanup \
    apt-get -y autore && rm -rf /var/lib/apt/lists/*;

EXPOSE 32400/tcp 3005/tcp 8324/tcp 32469/tcp 1900/udp 32410/udp 32412/udp 32413/udp 32414/udp
VOLUME /config /transcode

ENV CHANGE_CONFIG_DIR_OWNERSHIP="true" \
    HOME="/config"

ARG TAG=plexpass
ARG URL=

COPY root/ /

RUN \
# Save version and install
    /installBinary.sh

HEALTHCHECK --interval=200s --timeout=100s CMD /healthcheck.sh || exit 1

