# Since deskmate-sdl2 depends on the desmkate library,
# this Docker image has to be constructed from the repo's
# root directory:
# docker build -f ./code/sdl2/Dockerfile -t deskmate-sdl2 .
FROM alpine:3.12

RUN apk add --no-cache git clang cmake make binutils build-base libc-dev g++ sdl2-static sdl2_ttf-dev samurai openssl-dev

# Download, compile and install SDL2_gfx.
RUN mkdir /opt/SDL2_gfx && \
    cd /opt/SDL2_gfx && \
    wget http://www.ferzkopp.net/Software/SDL2_gfx/SDL2_gfx-1.0.4.tar.gz && \
    tar zxvf SDL2_gfx-1.0.4.tar.gz && \
    cd SDL2_gfx-1.0.4 && \
    ./configure && \
    make && \
    make install

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