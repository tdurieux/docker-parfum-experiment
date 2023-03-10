FROM ruby:2.3.8

# Cleanup expired Let's Encrypt CA (Sept 30, 2021)
RUN sed -i '/^mozilla\/DST_Root_CA_X3/s/^/!/' /etc/ca-certificates.conf && update-ca-certificates -f

# Install dependencies
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
  libzmq3-dev sox libsox-fmt-mp3 festival nodejs && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /app
