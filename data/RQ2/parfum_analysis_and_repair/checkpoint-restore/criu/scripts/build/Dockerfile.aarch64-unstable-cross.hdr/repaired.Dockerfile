FROM docker.io/dockcross/base:latest

ENV ARCH=aarch64
ENV DEBIAN_ARCH=arm64
ENV CROSS_TRIPLET=aarch64-linux-gnu