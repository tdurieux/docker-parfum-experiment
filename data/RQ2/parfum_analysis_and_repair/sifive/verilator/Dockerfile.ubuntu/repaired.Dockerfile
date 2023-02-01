FROM ubuntu:16.04
RUN apt-get update && apt-get install --no-install-recommends -y \
  autoconf \
  bison \
  flex \
  g++ \
  make \
  python3 && rm -rf /var/lib/apt/lists/*;
WORKDIR /usr/src/app
