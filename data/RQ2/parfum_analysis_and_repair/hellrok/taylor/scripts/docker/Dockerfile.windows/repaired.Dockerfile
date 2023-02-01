FROM debian:stable-slim

# Libraries are in order
# 1. Core
# 2. Exporting

RUN \
  apt-get update -y && \
  apt-get upgrade -y && \
  apt-get install -y --no-install-recommends \
    build-essential \
    git \
    ruby \
    mingw-w64 \
    \
    locales \
    zip && \
  apt-get clean -y && apt-get autoremove -y && \
  \
  sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  dpkg-reconfigure --frontend=noninteractive locales && \
  update-locale LANG=en_US.UTF-8 && rm -rf /var/lib/apt/lists/*;
