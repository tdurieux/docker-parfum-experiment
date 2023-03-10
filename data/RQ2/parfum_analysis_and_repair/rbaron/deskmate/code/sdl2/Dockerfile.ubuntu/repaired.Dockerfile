# Since deskmate-sdl2 depends on the desmkate library,
# this Docker image has to be constructed from the repo's
# root directory:
# docker build -f ./code/sdl2/Dockerfile.ubuntu -t deskmate-sdl2-ubuntu .
FROM ubuntu:20.04

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    apt-get -y --no-install-recommends install git make cmake clang clang-format ninja-build libsdl2-dev libsdl2-ttf-dev libsdl2-gfx-dev && rm -rf /var/lib/apt/lists/*;

# Paho dependencies.
RUN apt-get -y --no-install-recommends install build-essential gcc make cmake cmake-gui cmake-curses-gui libssl-dev && rm -rf /var/lib/apt/lists/*;

COPY . /app

WORKDIR /app/code/sdl2

# Install dependencies
RUN git submodule update --init --recursive && \
    cd third-party/paho.mqtt.c && \
    mkdir build && \
    cd build && \
    cmake -GNinja -DPAHO_WITH_SSL=TRUE -DPAHO_BUILD_SAMPLES=TRUE .. && \
    ninja

# Build deskmate-sdl2
RUN cd /app/code/sdl2 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make