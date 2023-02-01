FROM ioft/i386-ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y build-essential cmake pkg-config libfreetype6-dev libvorbis-dev libgl1-mesa-dev libpulse-dev libpng12-dev zip gettext && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y python-software-properties software-properties-common && \
add-apt-repository ppa:ubuntu-toolchain-r/test && \
apt-get update && \
 apt-get install --no-install-recommends -y gcc-4.8 g++-4.8 && \
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 50 && \
update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 50 && rm -rf /var/lib/apt/lists/*;

COPY source/misc/standalone/compile_requirements.sh /
RUN /compile_requirements.sh



COPY . /staging/blockattack-game

ENV BLOCKATTACK_VERSION 2.3.0

RUN cd /staging/blockattack-game && \
./packdata.sh && \
cmake -D Boost_USE_STATIC_LIBS=ON -D INSTALL_DATA_DIR=. -D CMAKE_INSTALL_PREFIX=. -D STANDALONE=1 . && make
