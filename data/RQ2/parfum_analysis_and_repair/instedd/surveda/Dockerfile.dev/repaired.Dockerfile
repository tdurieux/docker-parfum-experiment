FROM elixir:1.8

# Cleanup expired Let's Encrypt CA (Sept 30, 2021)
RUN sed -i '/^mozilla\/DST_Root_CA_X3/s/^/!/' /etc/ca-certificates.conf && update-ca-certificates -f

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y mysql-client inotify-tools sox libsox-fmt-mp3 festival vim && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mix local.hex --force
RUN mix local.rebar --force
