#
# This Dockerfile installs dependencies for running HERO Radar Odometry.
#
# To use this Dockerfile, use the `docker build` command.
# See https://docs.docker.com/engine/reference/builder/
# for more information.
#
FROM nvcr.io/nvidia/cuda:10.1-cudnn7-runtime

# python
RUN apt update
RUN apt upgrade -y --no-install-recommends
RUN apt-get update
RUN apt-get install gcc g++ python3 python3-pip python3-dev libglib2.0-0 libgl1-mesa-glx -y --no-install-recommends

# Install pip packages
RUN pip3 install --upgrade setuptools
RUN pip3 install --upgrade pip
RUN pip3 install torch==1.7.1+cu101 torchvision==0.8.2+cu101 -f https://download.pytorch.org/whl/torch_stable.html
RUN pip3 install tensorboard
RUN pip3 install -Iv tensorboardx==2.1 matplotlib==3.2.2 opencv-python==4.5.1.48
RUN pip3 install numpy==1.19.4 sklearn Pillow==8.0

# git and wget
RUN apt-get udpate
RUN apt install git wget -y --no-install-recommends

# cmake
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt install -y libprotobuf-dev protobuf-compiler
RUN apt install -y cmake

# boost
RUN cd /usr/src && \
 wget --no-verbose https://boostorg.jfrog.io/artifactory/main/release/1.76.0/source/boost_1_76_0.tar.gz && \
 tar xzf boost_1_76_0.tar.gz && \
 cd boost_1_76_0 && \
 ./bootstrap.sh --with-python=$(which python3) && \
 ./b2 cxxflags="-std=gnu++17" install && \
 ldconfig && \
 cd / && rm -rf /usr/src/*

# eigen
RUN mkdir workspace && cd /workspace && \
 git clone https://gitlab.com/libeigen/eigen.git && \
 cd eigen && \
 git checkout 3.2.5 && \
 mkdir build && \
 cd build && \
 cmake .. && \
 make install

# lgmath (pre-catkin)
RUN cd /workspace && \
 git clone https://github.com/utiasASRL/lgmath.git && \
 cd lgmath && \
 git checkout 979eb07417affc0581d3d69cecae7e3737d04e57 && \
 mkdir build && \
 cd build && \
 cmake .. && \
 make && \
 make install

# steam (pre-catkin)
RUN cd /workspace && \
 git clone https://github.com/utiasASRL/steam.git && \
 cd steam && \
 git checkout feature/pointToPointErrorEval && \
 mkdir build && \
 cd build && \
 cmake .. && \
 make && \
 make install

# opencv
RUN cd /workspace && \
 git clone https://github.com/opencv/opencv.git && \
 cd opencv && \
 git checkout 3.4 && \
 mkdir build && \
 cd build && \
 cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D OPENCV_GENERATE_PKGCONFIG=ON .. && \
 make && \
 make install
