# rebased/repackaged base image that only updates existing packages
ARG BASE=mbentley/ubuntu:20.04
FROM ${BASE}

LABEL maintainer="Matt Bentley <mbentley@mbentley.net>"

ARG OMADA_VER=5.0.30
ARG OMADA_TAR="Omada_SDN_Controller_v${OMADA_VER}_linux_x64.tar.gz"
ARG OMADA_URL="https://static.tp-link.com/upload/software/2022/202201/20220120/${OMADA_TAR}"
# valid values: amd64 (default) | arm64 | armv7l
ARG ARCH=amd64

COPY install.sh healthcheck.sh /

# install omada controller (instructions taken from install.sh); then create a user & group and set the appropriate file system permissions
RUN /install.sh && rm /install.sh

# patch log4j vulnerability