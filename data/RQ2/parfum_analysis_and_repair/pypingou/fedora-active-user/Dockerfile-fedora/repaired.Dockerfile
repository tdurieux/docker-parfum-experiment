ARG BASE_IMAGE=fedora:30
FROM ${BASE_IMAGE}

RUN dnf -y upgrade \
  && dnf -y install \
  --setopt=tsflags=nodocs \
  # Runtime dependency
  python3 \
  && dnf clean all

WORKDIR /work
COPY . .