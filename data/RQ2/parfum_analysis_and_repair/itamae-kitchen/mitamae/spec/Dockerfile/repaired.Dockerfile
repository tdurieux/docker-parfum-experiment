# https://hub.docker.com/r/k0kubun/mitamae-spec/builds/
FROM ubuntu:20.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
  git \
  nginx \
  ruby \
  sudo \
  systemd && rm -rf /var/lib/apt/lists/*;
