# rebased/repackaged base image that only updates existing packages
ARG BASE=mbentley/ubuntu:18.04
FROM ${BASE}

LABEL maintainer="Matt Bentley <mbentley@mbentley.net>"

ARG OMADA_VER=4.4.8
ARG OMADA_TAR="Omada_SDN_Controller_v${OMADA_VER}_linux_x64.tar.gz"
ARG OMADA_URL="https://static.tp-link.com/upload/software/2021/202112/20211217/${OMADA_TAR}"
# valid values: amd64 (default) | arm64 | armv7l
ARG ARCH=armv71

COPY install.sh healthcheck.sh /

# install omada controller (instructions taken from install.sh); then create a user & group and set the appropriate file system permissions
RUN /install.sh && rm /install.sh

# patch log4j vulnerability