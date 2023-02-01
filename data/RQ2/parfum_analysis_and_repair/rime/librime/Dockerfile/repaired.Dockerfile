FROM ubuntu:18.04

RUN apt update
RUN apt install --no-install-recommends -y \
cmake \
libboost-dev \
libboost-filesystem-dev libboost-regex-dev libboost-system-dev libboost-locale-dev \
libgoogle-glog-dev \
libgtest-dev \
libyaml-cpp-dev \
libleveldb-dev \
libmarisa-dev && rm -rf /var/lib/apt/lists/*;

RUN apt install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

# Manually install libopencc
RUN git clone https://github.com/BYVoid/OpenCC.git
WORKDIR OpenCC/
RUN apt install --no-install-recommends -y doxygen && rm -rf /var/lib/apt/lists/*;
RUN make
RUN make install

# Fix libgtest problem during compiling
WORKDIR /usr/src/gtest
RUN cmake CMakeLists.txt
RUN make
#copy or symlink libgtest.a and libgtest_main.a to your /usr/lib folder
RUN cp *.a /usr/lib

# Build librime
WORKDIR /
RUN git clone https://github.com/rime/librime.git
WORKDIR librime/
RUN make
RUN make install
