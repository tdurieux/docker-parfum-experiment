FROM docker.io/dockcross/base:latest

ENV ARCH=arm
ENV SUBARCH=armv7
ENV DEBIAN_ARCH=armhf
ENV CROSS_TRIPLET=arm-linux-gnueabihf