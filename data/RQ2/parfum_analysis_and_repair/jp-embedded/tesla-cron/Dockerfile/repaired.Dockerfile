# Base on ubuntu 20.04 We could probably run with a simpler one, but for now, this.
FROM ubuntu:20.04

LABEL maintainer="Jan Pedersen" \
  TESLA_ACCOUNT_EMAIL="Configure your Tesla account email" \
  TESLA_SSO_REFRESH_TOKEN="Configure your Tesla SSO refresh token"

# We could fix the timezone here, for now, run with some default. UTC?
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata && rm -rf /var/lib/apt/lists/*;

# Install build support stuff 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install make git && rm -rf /var/lib/apt/lists/*;

# Install needed modules
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install build-essential libboost-all-dev libcurlpp-dev libcurl4-openssl-dev rapidjson-dev python3-pip librrd-dev && rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip install teslapy

# Build the system. This could be in a seperate docker
RUN git clone https://github.com/jp-embedded/tesla-cron.git && cd tesla-cron && git submodule update --init --recursive

# Now, build
RUN cd tesla-cron && make


# Everything ready, configure for entrypoint.sh
COPY entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
