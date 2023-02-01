FROM debian:bullseye-slim

LABEL description="Reconfigure Raspberry Pi images with an easy, Docker-like configuration file"
LABEL maintainer="hoechst@mathematik.uni-marburg.de"
LABEL version="0.6.0"

RUN apt-get update && \
  apt-get install --no-install-recommends -y \
  binfmt-support \
  fdisk \
  file \
  kpartx \
  lsof \
  p7zip-full \
  qemu \
  qemu-user-static \
  unzip \
  wget \
  xz-utils \
  units && rm -rf /var/lib/apt/lists/*;

RUN mkdir /pimod
COPY . /pimod/

ENV PATH="/pimod:${PATH}"
ENV PIMOD_CACHE=".cache"

WORKDIR /pimod
CMD pimod.sh Pifile
