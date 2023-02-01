FROM nvidia/cuda:11.2.2-devel-ubuntu18.04

LABEL maintainer="Zhe Zhang"

ARG DEBIAN_FRONTEND=non-interactive

# install general dependencies

RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    cmake \
    build-essential \
    vim && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y \
    libboost-program-options-dev \
    libboost-filesystem-dev \
    libboost-graph-dev \
    libboost-regex-dev \
    libboost-system-dev \
    libboost-test-dev \
    libeigen3-dev \
    libsuitesparse-dev \
    libfreeimage-dev \
    libgoogle-glog-dev \
    libgflags-dev \
    libglew-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y \
    qtbase5-dev \
    libqt5opengl5-dev \
    libcgal-dev \
    libcgal-qt5-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir /tools

# install ceres-solver

WORKDIR /tools
RUN apt-get update && apt-get install --no-install-recommends -y libatlas-base-dev libsuitesparse-dev && rm -rf /var/lib/apt/lists/*;
RUN git clone https://gitee.com/coolke/ceres-solver.git
WORKDIR /tools/ceres-solver
RUN git checkout $(git describe --tags)
RUN mkdir build
WORKDIR /tools/ceres-solver/build
RUN cmake .. -DBUILD_TESTING=OFF -DBUILD_EXAMPLES=OFF
RUN make -j4 && make install

# install colmap

WORKDIR /tools
RUN git clone https://gitee.com/liang-hao/colmap.git
WORKDIR /tools/colmap
RUN git checkout dev
RUN mkdir build
WORKDIR /tools/colmap/build
RUN cmake ..
RUN make -j4 && make install

# remove unneeded files
RUN rm -rf /tools

# RUN mkdir /home
RUN chmod -R 777 /home
ENV HOME /home
WORKDIR /home
