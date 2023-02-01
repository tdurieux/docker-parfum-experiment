FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -yy build-essential libphysfs-dev libboost-dev libfmt-dev cmake libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-ttf-dev libboost-program-options-dev libutfcpp-dev zip gettext && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /staging/blockattack-game

COPY . /staging/blockattack-game

ENV BLOCKATTACK_VERSION 2.9.0-SNAPSHOT

RUN cd /staging/blockattack-game && \
./packdata.sh && \
cmake . && \
make
