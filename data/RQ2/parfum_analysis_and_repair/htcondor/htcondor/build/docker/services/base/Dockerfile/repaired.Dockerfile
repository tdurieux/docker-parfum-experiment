# This is the base image for HTCondor; no role-specific config
ARG BASE_IMAGE=centos:7
FROM ${BASE_IMAGE}
ARG BASE_IMAGE
# ^^ Previous BASE_IMAGE has gone out of scope

ARG VERSION=latest
ARG SERIES=9.0

LABEL org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.title="HTCondor Base Image derived from ${BASE_IMAGE}" \
      org.opencontainers.image.vendor="HTCondor"

# Unset these from parent