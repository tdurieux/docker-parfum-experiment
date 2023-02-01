FROM debian:buster-slim

RUN apt-get update && apt-get install --no-install-recommends -y \
  build-essential \
  cmake \
  curl \
  doxygen \
  git \
  graphviz \
  libgdal-dev \
  libgeos-dev \
  unzip \
  wget && rm -rf /var/lib/apt/lists/*;
