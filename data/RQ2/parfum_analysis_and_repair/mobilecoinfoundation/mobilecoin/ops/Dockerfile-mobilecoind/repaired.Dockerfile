# ############# #
#  Mobilecoind  #
# ############# #
FROM ubuntu:18.04 AS mobilecoind
#
# This builds a slim runtime container based on Ubuntu 18.04 LTS for distribution of the mobilecoind program
#

SHELL ["/bin/bash", "-c"]

# Install any updates
#
RUN apt-get update -q -q && \
apt-get upgrade --yes --force-yes && \
 apt-get install --no-install-recommends --yes --force-yes \
ca-certificates \
gettext \
libssl1.1 \
supervisor \
wget && \
rm -rf /var/cache/apt && \
rm -rf /var/lib/apt/lists/*

# Add grpc_health_probe for healthcheck/liveness probes
RUN GRPC_HEALTH_PROBE_VERSION=v0.3.2 && \
    wget -qO/bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-amd64 && \
    chmod +x /bin/grpc_health_probe

WORKDIR /
COPY bin/mobilecoind /usr/bin/
COPY bin/mc-util-grpc-admin-tool /usr/bin/

# Q: Why not use NODE_LEDGER_DIR here?
# A: The ENV dictates where the app actually looks, and the ARG sets
#    the default ENV value, but the sample-keys install dir should
#    remain constant, and image builds may make that location their
#    default. -- jmc
ARG ORIGIN_DATA_DIR
COPY ${ORIGIN_DATA_DIR}/keys /var/lib/mobilecoin/keys
COPY ${ORIGIN_DATA_DIR}/ledger /var/lib/mobilecoin/ledger

COPY attest/test_certs/ /var/lib/mobilecoin/attest/test_certs

COPY entrypoints/mobilecoind.sh /usr/bin/entrypoint.sh

# Put arg and env configuration at the end when possible to improve use of docker layer caching
ARG MOBILECOIND_SERVICE_PORT=4444

ARG BRANCH
ARG NODE_LEDGER_DIR="/var/lib/mobilecoin/ledger"
ARG MOBILECOIND_DB_DIR="/var/lib/mobilecoin/mobilecoind_db"
ENV MOBILECOIND_SERVICE_PORT="${MOBILECOIND_SERVICE_PORT}"
ENV BRANCH="${BRANCH}"
ENV RUST_LOG "debug"
ENV RUST_BACKTRACE "full"
ENV RUST_LOG_STYLE "never"
ENV NODE_LEDGER_DIR=${NODE_LEDGER_DIR}
ENV MOBILECOIND_DB_DIR=${MOBILECOIND_DB_DIR}
ENV ORIGIN_DATA_DIR=${ORIGIN_DATA_DIR}
ENV GIT_COMMIT=${GIT_COMMIT}
ENV BRANCH=${BRANCH}

EXPOSE $MOBILECOIND_SERVICE_PORT

ENTRYPOINT ["entrypoint.sh"]
