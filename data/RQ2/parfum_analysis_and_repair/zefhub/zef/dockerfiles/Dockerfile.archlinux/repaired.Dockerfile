# This should be run from the zef repo root
FROM archlinux:latest

RUN pacman -Syu --noconfirm
RUN pacman -S --noconfirm \
    base-devel \
    python \
    python-pip \
    curl \
    zstd \
    openssl \
    git \
    jq

COPY . .

RUN LIBZEF_LOCATION=$(realpath core) pip3 --no-cache-dir install ./python
