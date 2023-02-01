FROM ubuntu:18.04

RUN apt update && \
  DEBIAN_FRONTEND='noninteractive' \
  DEBCONF_NONINTERACTIVE_SEEN='true' \
  apt --no-install-recommends \
  install --yes \
    build-essential \
    cmake \
    gfortran \
    libblas-dev \
    liblapack-dev \
    libmpich-dev \
    libproj-dev \
    python3 && rm -rf /var/lib/apt/lists/*;
