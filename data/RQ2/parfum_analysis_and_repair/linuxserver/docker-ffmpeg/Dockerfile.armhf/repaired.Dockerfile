FROM ghcr.io/linuxserver/ffmpeg:arm32v7-bin as binstage
FROM ghcr.io/linuxserver/baseimage-ubuntu:arm32v7-bionic

# Add files from binstage
COPY --from=binstage / /

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

ARG DEBIAN_FRONTEND="noninteractive"

RUN \
  echo "**** install runtime ****" && \
  apt-get update && \
  apt-get install --no-install-recommends -y \
    libexpat1 \
    libfontconfig1 \
    libglib2.0-0 \
    libgomp1 \
    libharfbuzz0b \
    libv4l-0 \
    libx11-6 \
    libxcb1 \
    libxext6 \
    libxml2 && \
  echo "**** clean up ****" && \
  rm -rf \
    /var/lib/apt/lists/* \
    /var/tmp/*

COPY /root /

ENTRYPOINT ["/ffmpegwrapper.sh"]
