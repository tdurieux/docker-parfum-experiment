FROM ubuntu:eoan as ubuntu-base

ENV LANG C.UTF-8

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
        python3 \
        libportaudio2 libatlas3-base libgfortran4 \
        ca-certificates \
        perl sox alsa-utils espeak jq && rm -rf /var/lib/apt/lists/*;

FROM ubuntu-base as base-amd64

FROM ubuntu-base as base-armv7

FROM ubuntu-base as base-arm64

ARG TARGETARCH
ARG TARGETVARIANT
FROM base-$TARGETARCH$TARGETVARIANT
