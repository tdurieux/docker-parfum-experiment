FROM arradev/cardano-node:latest AS node
FROM arradev/cardano-address:latest AS address
FROM arradev/bech32:latest AS bech32
FROM arradev/cncli:latest AS cncli
#FROM arradev/cardano-voting:latest AS voting
FROM debian:stable-20210816-slim
LABEL maintainer="dro@arrakis.it"

SHELL ["/bin/bash", "-c"]
WORKDIR /

# Install tools
RUN apt-get update -y && apt-get install --no-install-recommends -y vim procps dnsutils bc curl nano cron python3 python3-pip tmux jq wget \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir pytz

# Copy compiled binaries
COPY --from=node /bin/cardano* /bin/
COPY --from=node /lib/libsodium* /lib/
COPY --from=cncli /bin/cncli /bin/
COPY --from=address /bin/cardano-address /bin/
COPY --from=bech32 /bin/bech32 /bin/
#COPY --from=voting /bin/voting-tools /bin/
#COPY --from=voting /bin/voter-registration /bin/

# Expose ports
## cardano-node, EKG, Prometheus
EXPOSE 3000 12788 12798

# ENV variables
ENV NODE_PORT="3000" \
    NODE_NAME="node1" \
    NODE_TOPOLOGY="" \
    NODE_RELAY="False" \
    CARDANO_NETWORK="main" \
    EKG_PORT="12788" \
    PROMETHEUS_PORT="12798" \
    RESOLVE_HOSTNAMES="False" \
    REPLACE_EXISTING_CONFIG="False" \
    POOL_TICKER="" \
    POOL_PLEDGE="100000000000" \
    POOL_COST="10000000000" \
    POOL_MARGIN="0.05" \
    AUTO_TOPOLOGY="True" \
    METADATA_URL="" \
    PUBLIC_RELAY_IP="TOPOLOGY" \
    PUBLIC_RELAY_HOST="" \
    WAIT_FOR_SYNC="True" \
    PATH="/root/.local/bin/:/scripts/:/scripts/functions/:/cardano-node/scripts/:${PATH}" \
    LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH}" \
    CARDANO_NODE_SOCKET_PATH="DEFAULT" \
    CNCLI_SYNC="True" \
    STATUS_PANEL="False" \
    PT_API_KEY="" \
    PT_SENDTIP="False" \
    PT_SENTSLOTS="False" \
    LANG="C.UTF-8"

# Add config
ADD cfg-templates/ /cfg-templates/
RUN mkdir -p /config/
VOLUME /config/

# Add scripts
ADD scripts/ /scripts/
RUN chmod -R +x /scripts/

ENTRYPOINT ["/scripts/start-cardano-node"]
