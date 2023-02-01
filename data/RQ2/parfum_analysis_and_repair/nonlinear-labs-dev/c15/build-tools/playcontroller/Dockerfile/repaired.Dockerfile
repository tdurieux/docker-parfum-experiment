FROM ubuntu:20.04

ENV LANG en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get install --no-install-recommends -y git gcc-arm-none-eabi cmake build-essential crossbuild-essential-armhf crossbuild-essential-armel pkg-config && rm -rf /var/lib/apt/lists/*;
