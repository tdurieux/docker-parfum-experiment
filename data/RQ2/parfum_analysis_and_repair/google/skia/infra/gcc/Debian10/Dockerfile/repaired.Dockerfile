FROM debian:10-slim

RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y \
  build-essential \
  ca-certificates \
  libfontconfig-dev \
  libglu-dev \
  python3 \
  && rm -rf /var/lib/apt/lists/*
RUN ln -s /usr/bin/python3 /usr/bin/python