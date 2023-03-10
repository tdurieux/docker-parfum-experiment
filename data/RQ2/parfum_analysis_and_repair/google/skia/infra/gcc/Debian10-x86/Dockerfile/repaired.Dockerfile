FROM debian:10-slim

RUN dpkg --add-architecture i386 && \
  apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y \
  build-essential \
  ca-certificates \
  g++-multilib \
  libfontconfig-dev:i386 \
  libglu-dev:i386 \
  python3 \
  && rm -rf /var/lib/apt/lists/*
RUN ln -s /usr/bin/python3 /usr/bin/python
