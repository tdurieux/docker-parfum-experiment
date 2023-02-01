FROM ubuntu:16.04

ENV DEPOT_TOOLS_PATH $HOME/depot_tools
ENV ENGINE_PATH $HOME/engine

RUN apt-get update
RUN apt-get install -y git wget curl unzip python lsb-release sudo

RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git $DEPOT_TOOLS_PATH
ENV PATH $PATH:$DEPOT_TOOLS_PATH

RUN mkdir --parents $ENGINE_PATH
WORKDIR $ENGINE_PATH
ADD engine_gclient .gclient
RUN gclient sync

WORKDIR $ENGINE_PATH/src
RUN ./build/install-build-deps.sh --no-prompt
RUN ./build/install-build-deps-android.sh --no-prompt
RUN ./flutter/build/install-build-deps-linux-desktop.sh
