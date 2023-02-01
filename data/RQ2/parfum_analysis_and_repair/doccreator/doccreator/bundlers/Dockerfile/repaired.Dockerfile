From ubuntu:focal
MAINTAINER Boris Mansencal boris.mansencal@labri.fr

ARG DEBIAN_FRONTEND=noninteractive
ARG DEBCONF_NONINTERACTIVE_SEEN=true

RUN apt-get update -qy && apt install --no-install-recommends -qy libc++-dev libc++abi-dev libopencv-dev qtbase5-dev qtdeclarative5-dev libqt5xmlpatterns5-dev cmake wget unzip g++ git && rm -rf /var/lib/apt/lists/*;

RUN wget https://github.com/DocCreator/DocCreator/archive/master.zip
RUN unzip master.zip
RUN cd DocCreator-master && mkdir build && cd build && cmake .. && make

# Env vars for the nvidia-container-runtime.
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute

