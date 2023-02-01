# Based on https://github.com/RHsyseng/container-rhel-examples/blob/master/starter-rhel-atomic/Dockerfile
FROM registry.centos.org/centos/centos7-atomic:latest
MAINTAINER Risu developers <risuorg _AT_ googlegroups.com>

LABEL name="risu/risu" \
  maintainer="risuorg _AT_ googlegroups.com" \
  vendor="Risu" \
  version="1.0.0" \
  release="1" \
  summary="System configuration validation program" \
  description="Risu is a program that should help with system configuration validation on either live system or any sort of snapshot of the filesystem."

ENV USER_NAME=risu \
  USER_UID=10001 \
  LC_ALL=en_US.utf8

# Required for useradd command and pip