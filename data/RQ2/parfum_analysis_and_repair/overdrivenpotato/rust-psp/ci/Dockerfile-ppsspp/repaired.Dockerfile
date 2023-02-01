FROM ubuntu:latest as ppsspp

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get -y update && apt-get install --no-install-recommends -y build-essential cmake git libsdl2-dev python libglew-dev && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/hrydgard/ppsspp --recursive
WORKDIR /ppsspp/build-sdl
RUN cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_SKIP_RPATH=ON \
    -DHEADLESS=ON \
    -DUSE_SYSTEM_LIBZIP=ON
RUN make
RUN make install
