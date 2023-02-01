FROM debian:latest

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  bash-builtins \
  gcc \
  libc6-dev \
  make \
  pkgconf && rm -rf /var/lib/apt/lists/*;

WORKDIR /root
CMD make clean ini.so
