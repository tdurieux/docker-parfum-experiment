FROM balenalib/rpi-raspbian:buster

USER root

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update --allow-insecure-repositories
RUN apt-get install --no-install-recommends --allow-unauthenticated -y \
        gcc \
        g++ \
        scons \
        libsdl2-dev \
        libsdl2-net-dev \
        libsdl-dev \
        libsdl-net1.2-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir /plutoboy_linux
COPY ./build /plutoboy_linux/build
COPY ./src/platforms/standard /plutoboy_linux/src/platforms/standard
COPY ./src/shared_libs /plutoboy_linux/src/shared_libs
COPY ./src/core /plutoboy_linux/src/core
COPY ./src/non_core /plutoboy_linux/src/non_core

RUN apt-get install --no-install-recommends python3-pip --allow-unauthenticated -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir scons

WORKDIR /plutoboy_linux/build/Unix

ENV cc="gcc" framework="SDL2" mode="release"

CMD cd /plutoboy_linux/build/Unix \
    && scons cc=${cc} framework=${framework} mode=${mode} \
    && cp plutoboy /mnt
