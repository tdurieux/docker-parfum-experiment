FROM debian:stretch-slim

# Install basic required packages.
RUN set -x \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        dumb-init \
        xmlstarlet \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN set -x \
    # Upgrade to get possible critical fixes.
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y --no-install-recommends \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
    # Create plex user
 && useradd --system --uid 797 --create-home --shell /usr/sbin/nologin plex \
    # Download and install Plex (non plexpass) after displaying downloaded URL in the log.
    # This gets the latest non-plexpass version
    # Note: We created a dummy /bin/start to avoid install to fail due to upstart not being installed.
    # We won't use upstart anyway.
 && curl -I 'https://plex.tv/downloads/latest/1?channel=8&build=linux-ubuntu-x86_64&distro=ubuntu' \
 && curl -L 'https://plex.tv/downloads/latest/1?channel=8&build=linux-ubuntu-x86_64&distro=ubuntu' -o plexmediaserver.deb \
 && touch /bin/start \
 && chmod +x /bin/start \
 && dpkg -i plexmediaserver.deb \
 && rm -f plexmediaserver.deb \
 && rm -f /bin/start \
    # Create writable config directory in case the volume isn't mounted
 && mkdir /config \
 && chown plex:plex /config

# PLEX_MEDIA_SERVER_MAX_PLUGIN_PROCS: The number of plugins that can run at the same time.
# PLEX_MEDIA_SERVER_MAX_STACK_SIZE: Used for "ulimit -s $PLEX_MEDIA_SERVER_MAX_STACK_SIZE".
# PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR: defines the location of the configuration directory,
#   default is "${HOME}/Library/Application Support".
ENV PLEX_MEDIA_SERVER_MAX_PLUGIN_PROCS=6 \
    PLEX_MEDIA_SERVER_MAX_STACK_SIZE=3000 \
    PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR=/config \
    PLEX_MEDIA_SERVER_HOME=/usr/lib/plexmediaserver \
    LD_LIBRARY_PATH=/usr/lib/plexmediaserver \
    TMPDIR=/tmp

COPY root /

VOLUME ["/config", "/media"]

EXPOSE 32400

USER plex

WORKDIR /usr/lib/plexmediaserver
ENTRYPOINT ["dumb-init", "/plex-entrypoint.sh"]
CMD ["/usr/lib/plexmediaserver/Plex Media Server"]
