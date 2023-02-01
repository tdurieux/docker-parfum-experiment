FROM ubuntu:20.04

# Correctly install tzdata (which normally has interactive prompts) for Docker image
RUN DEBIAN_FRONTEND="noninteractive" TZ="America/New_York" apt-get -y update && apt-get -y --no-install-recommends install tzdata && rm -rf /var/lib/apt/lists/*;

# Get general dependencies:
RUN apt-get -y update && apt-get -y --no-install-recommends install cmake lsb-release curl build-essential gnutls-bin && rm -rf /var/lib/apt/lists/*;

# Update and install remaining package dependencies
RUN apt-get -y update && apt-get -y --no-install-recommends install sudo openssh-client \
  software-properties-common libgl1-mesa-dev libglew-dev libwayland-dev \
  libxkbcommon-dev wayland-protocols git && rm -rf /var/lib/apt/lists/*;

# GCC/G++9 needed
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get -y update && apt-get -y --no-install-recommends install gcc-9 g++-9 && rm -rf /var/lib/apt/lists/*;

# Ensure we use the gcc-9 and g++-9
RUN export CC=/usr/bin/gcc-9
RUN export CXX=/usr/bin/g++-9

# libboost required by GTSAM
RUN apt-get -y update && apt-get -y --no-install-recommends install libboost-all-dev libtbb-dev && rm -rf /var/lib/apt/lists/*;

# Build and install GTSAM
RUN git clone https://github.com/borglab/gtsam.git && \
  cd gtsam && \
  git checkout caa14bc && \
  cd .. && \
	mkdir gtsam/build && cd gtsam/build && \
  cmake .. && make -j8 install

# libgtest needed for DCSAM
RUN apt-get -y update && apt-get -y --no-install-recommends install libprotobuf-dev protobuf-compiler libgtest-dev && rm -rf /var/lib/apt/lists/*;

RUN cd /usr/src/gtest && mkdir build && cd build && cmake .. -DBUILD_SHARED_LIBS=ON && make && ls lib && cp /usr/src/gtest/build/lib/* /usr/include/

# Eigen3.3 needed for DCSAM
RUN apt-get -y update && apt-get -y --no-install-recommends install libeigen3-dev && rm -rf /var/lib/apt/lists/*;
