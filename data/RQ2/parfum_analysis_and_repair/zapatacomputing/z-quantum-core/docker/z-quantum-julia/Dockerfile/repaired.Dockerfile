# Dockerfile for the default OpenPack docker image
FROM zapatacomputing/z-quantum-default:latest

ARG JULIA_MINOR_VERSION=1.7
ARG JULIA_PATCH_VERSION=1.7.2
WORKDIR /root

# get julia