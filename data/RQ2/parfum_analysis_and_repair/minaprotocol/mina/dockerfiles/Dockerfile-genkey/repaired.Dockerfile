#################################################################################################
# The "production" Stage
# - sets up the final container with built binaries and a running postgresql archive node setup
#################################################################################################
FROM debian:stretch-slim AS production

ENV DEBIAN_FRONTEND noninteractive

# Dependencies
# stretch-slim configures apt to not store any cache, so no need to rm it
# TODO: make sure this is the minimum runtime deps
RUN apt-get -y update \
  && apt -y --no-install-recommends install \
    apt-transport-https \
    ca-certificates \
    dnsutils \
    dumb-init \
    libffi6 \
    libgmp10 \
    libgomp1 \
    libprocps6 \
    libjemalloc-dev \
    libssl1.1 \
    tzdata && rm -rf /var/lib/apt/lists/*;

# mina keypair package
RUN echo "deb [trusted=yes] http://packages.o1test.net stretch stable" > /etc/apt/sources.list.d/o1.list \
   && apt-get update \
   || sleep 10s && apt-get update \
   || sleep 10s && apt-get update \
   || sleep 10s && apt-get update \
   && apt-get install --no-install-recommends -y "mina-generate-keypair=1.2.1beta1-45440dc" && rm -rf /var/lib/apt/lists/*;

WORKDIR /

ENTRYPOINT [ "mina-generate-keypair" ]
