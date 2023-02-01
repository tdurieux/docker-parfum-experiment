FROM ioft/i386-ubuntu:14.04

RUN apt-get update && apt-get install -y build-essential libboost-dev cmake pkg-config libboost-program-options-dev libfreetype6-dev libvorbis-dev libgl1-mesa-dev libpulse-dev libutfcpp-dev zip gettext

COPY source/misc/standalone/compile_requirements.sh /
RUN /compile_requirements.sh

COPY . /staging/blockattack-game

ENV BLOCKATTACK_VERSION 2.6.0-SNAPSHOT

RUN cd /staging/blockattack-game && \
./packdata.sh && \
cmake -D Boost_USE_STATIC_LIBS=ON -D INSTALL_DATA_DIR=. -D CMAKE_INSTALL_PREFIX=. -D STANDALONE=1 . && make
