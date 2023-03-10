FROM ubuntu:18.04 AS builder

ARG BITCOIN_CASH_VERSION

RUN apt-get update && apt-get install --no-install-recommends -y \
ca-certificates \
curl \
&& rm -rf /var/lib/apt/lists/*

RUN curl -f https://download.bitcoinabc.org/$BITCOIN_CASH_VERSION/linux/bitcoin-abc-${BITCOIN_CASH_VERSION}-x86_64-linux-gnu.tar.gz \
| tar xz --wildcards --strip 2 \
*/bin/bitcoind \
*/bin/bitcoin-cli



FROM ubuntu:18.04

# ROLE is bitcoin node role: primary or secondary.
#
# Primary role means that this node will init new blockchain if it not
# exists during deploy or restart.
#
# Secondary rank means that this node will try to connect to primary
# node and use blockchain of latter.
ARG ROLE

# RPC port.
EXPOSE 9332

# P2P port.
EXPOSE 9333

# Copying required binaries from builder stage.
COPY --from=builder bitcoind  /usr/local/bin/bitcoin-cashd
COPY --from=builder bitcoin-cli /usr/local/bin/bitcoin-cash-cli

# Default config used to initalize datadir volume at first or
# cleaned deploy.
COPY bitcoin.simnet.$ROLE.conf /root/default/bitcoin.conf

# Entrypoint script used to init datadir if required and for
# starting bitcoin cash daemon.
COPY entrypoint.sh /root/

# We are using exec syntax to enable gracefull shutdown. Check
# http://veithen.github.io/2014/11/16/sigterm-propagation.html.
ENTRYPOINT ["bash", "/root/entrypoint.sh"]