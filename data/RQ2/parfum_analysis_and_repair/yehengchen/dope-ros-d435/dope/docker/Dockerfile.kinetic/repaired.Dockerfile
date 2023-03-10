FROM nvidia/cudagl:9.0-devel-ubuntu16.04

# Copyright (c) 2018, NVIDIA CORPORATION. All rights reserved.
# Full license terms provided in LICENSE.md file.

# Build with:
# nvidia-docker build -t nvidia-dope:kinetic-v1 -f Dockerfile.kinetic ..

ENV HOME /root

WORKDIR ${HOME}

RUN apt-get update && apt-get -y --no-install-recommends install software-properties-common && rm -rf /var/lib/apt/lists/*;

# cuDNN version must match the one used by TensorRT.
# TRT 4.0 is compiled with cuDNN 7.1.

RUN apt-get update && apt-get -y --no-install-recommends install \
        ca-certificates \
        build-essential \
        cmake \
        git \
        libcudnn7=7.1.4.18-1+cuda9.0 \
        libcudnn7-dev=7.1.4.18-1+cuda9.0 \
        libopencv-dev \
        python-dev \
        python-pip \
    && apt-get -y autoremove \
    && apt-get clean \
    # pip \
    && pip install --no-cache-dir setuptools wheel \
    # cleanup
    && rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/* && rm -rf /var/lib/apt/lists/*;

# Install OpenCV with CUDA support.
# REVIEW alexeyk: JetPack 3.2 comes with OpenCV 3.3.1 _without_ CUDA support.
WORKDIR ${HOME}
RUN git clone http://github.com/opencv/opencv.git && cd opencv \
    && git checkout 3.3.1                   \
    && mkdir build && cd build              \
    && cmake -D CMAKE_BUILD_TYPE=RELEASE    \
        -D CMAKE_INSTALL_PREFIX=/usr/local  \
        -D WITH_CUDA=OFF                     \
        -D WITH_OPENCL=OFF                  \
        -D ENABLE_FAST_MATH=1               \
        -D CUDA_FAST_MATH=1                 \
        -D WITH_CUBLAS=1                    \
        -D BUILD_DOCS=OFF                   \
        -D BUILD_PERF_TESTS=OFF             \
        -D BUILD_TESTS=OFF                  \
        ..                                  \
    && make -j `nproc`                      \
    && make install                         \
    && cd ${HOME} && rm -rf ./opencv/

# ROS Kinetic
# Use rosdep to install all dependencies (including ROS itself)
COPY package.xml ${HOME}/fake_ws/src/dope/
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 \
    && sh -c 'echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list'  \
    && apt-get update && apt-get install --no-install-recommends -y python-rosdep \
    && rosdep init \
    && rosdep update \
    && rosdep install --from-paths ${HOME}/fake_ws/src -i -y --rosdistro kinetic \
    && apt-get install --no-install-recommends -y ros-kinetic-rosbash ros-kinetic-ros-comm \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/* && rm -rf /var/lib/apt/lists/*;

# Setup catkin workspace
ENV CATKIN_WS ${HOME}/catkin_ws
COPY . ${CATKIN_WS}/src/dope
COPY docker/init_workspace.sh ${HOME}
RUN ${CATKIN_WS}/src/dope/docker/init_workspace.sh

RUN echo "source ${CATKIN_WS}/devel/setup.bash" >> ${HOME}/.bashrc

ENV DISPLAY :0
ENV TERM=xterm
# Some QT-Apps don't not show controls without this
ENV QT_X11_NO_MITSHM 1

COPY requirements.txt ${HOME}
RUN pip install --no-cache-dir -r requirements.txt
