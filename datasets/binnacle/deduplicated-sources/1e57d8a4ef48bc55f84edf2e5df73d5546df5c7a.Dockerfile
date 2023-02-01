FROM ubuntu:12.04

RUN apt-get update && apt-get install -y build-essential cmake pkg-config libfreetype6-dev libvorbis-dev libgl1-mesa-dev libpulse-dev libpng12-dev zip gettext

RUN apt-get update && apt-get install -y python-software-properties && \
add-apt-repository ppa:ubuntu-toolchain-r/test && \
apt-get update && \
apt-get install -y gcc-4.8 g++-4.8 && \
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 50 && \
update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 50

COPY source/misc/standalone/compile_requirements.sh /
RUN /compile_requirements.sh



COPY . /staging/blockattack-game

ENV BLOCKATTACK_VERSION 2.6.0-SNAPSHOT

RUN cd /staging/blockattack-game && \
./packdata.sh && \
cp source/misc/travis_help/utf8_v2_3_4/source/utf8.h source/code/ && \
cp source/misc/travis_help/utf8_v2_3_4/source/utf8.h source/code/sago/ && \
cp -r source/misc/travis_help/utf8_v2_3_4/source/utf8 source/code/ && \
cp -r source/misc/travis_help/utf8_v2_3_4/source/utf8 source/code/sago/ && \
cmake -D Boost_USE_STATIC_LIBS=ON -D INSTALL_DATA_DIR=. -D CMAKE_INSTALL_PREFIX=. -D STANDALONE=1 . && make
