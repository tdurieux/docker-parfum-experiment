FROM yeetzone/dontstarvetogether-base
MAINTAINER YEET Zone <support@yeet.zone>

# Set build arguments.
ARG STORAGE_PATH="/opt/storage"
ENV STORAGE_PATH ${STORAGE_PATH}
ARG STEAM_APP="343050"
ENV STEAM_APP ${STEAM_APP}

# Set default environment.
ENV CLUSTER_NAME="cluster"
ENV SHARD_NAME="shard"
ENV SERVER_PORT="10999"
ENV SHARD_BIND_IP="0.0.0.0"
ENV ENCODE_USER_PATH=true
ENV BACKUP_LOG_COUNT=0

# Copy files.
COPY /scripts/dontstarvetogether /usr/local/bin/
COPY /scripts/ "$STEAM_HOME/scripts/"
COPY /data/ "$STEAM_HOME/data/"
COPY /entrypoint.sh /

# Set permissions.
RUN set -ex \
	&& mkfifo "$STEAM_HOME/console" \
	&& chmod -R +x "$STEAM_HOME/scripts/" \
	&& chmod +x /usr/local/bin/dontstarvetogether \
	&& chmod +x /entrypoint.sh \
	&& sync

# Set up healthcheck.
HEALTHCHECK --start-period=15m --interval=5m --timeout=1m --retries=3 CMD dontstarvetogether version --check

# Set volumes.
VOLUME "$STORAGE_PATH"

# Set working directory.
WORKDIR "$STEAM_PATH/bin"

# Set entrypoint.
ENTRYPOINT ["/entrypoint.sh"]

# Set command.
CMD ["dontstarvetogether", "start", "--update"]