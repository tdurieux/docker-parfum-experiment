# Glibc is required for Factorio Server binaries to run
FROM ubuntu

ENV FACTORIO_VERSION=stable \
    RCON_PASS=""

VOLUME /opt/fsm-data /opt/factorio/saves /opt/factorio/mods /opt/factorio/config

EXPOSE 80/tcp 34197/udp

RUN apt-get update && apt-get install --no-install-recommends -y curl tar xz-utils unzip jq && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

# Install FSM
COPY factorio-server-manager-linux.zip /factorio-server-manager-linux.zip
RUN unzip /factorio-server-manager-linux.zip \
    && rm /factorio-server-manager-linux.zip \
    && mv factorio-server-manager fsm

COPY entrypoint.sh /opt

ENTRYPOINT ["/opt/entrypoint.sh"]
