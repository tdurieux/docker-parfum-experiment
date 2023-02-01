FROM nvidia/cudagl:9.0-devel-ubuntu16.04

# Copyright (c) 2018, NVIDIA CORPORATION. All rights reserved.
# Full license terms provided in LICENSE.md file.

# Build with:
# nvidia-docker build -t nvidia-dope:kinetic-v1 -f Dockerfile.kinetic ..

ENV HOME /root

WORKDIR ${HOME}

RUN apt-get update && apt-get -y  --no-install-recommends install software-properties-common

# cuDNN version must match the one used by TensorRT.
# TRT 4.0 is compiled with cuDNN 7.1.

RUN apt-get update && apt-get -y --no-install-recommends install \
        ant \
        bzip2 \
        ca-certificates \
        ccache \
        cmake \
        curl \
        genromfs \
        git \
        gosu \
        iproute \
        iputils-ping \
        less \
        lcov \
        libcudnn7=7.1.4.18-1+cuda9.0 \
        libcudnn7-dev=7.1.4.18-1+cuda9.0 \
        libeigen3-dev \
        libopencv-dev \
        make \
        nano \
        net-tools \
        ninja-build \
        openjdk-8-jdk \
        patch \
        pkg-config \
        protobuf-compiler \
        python-argparse \
        python-dev \
        python-empy \
        python-numpy \
        python-pip \
        python-serial \
        python-software-properties \
        rsync \
        s3cmd \
        software-properties-common \
        sudo \
        unzip \
        xsltproc \
        wget \
        zip \
    && apt-get -y autoremove \
    && apt-get clean autoclean \
    # pip
    && pip install setuptools wheel \
    && pip install 'matplotlib==2.2.2' --force-reinstall \
    # coveralls code coverage reporting
    && pip install cpp-coveralls \
    # jinja template generation
    && pip install jinja2 \
    # cleanup
    && rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*

# ROS Kinetic
WORKDIR ${HOME}
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 \
    && sh -c 'echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list' \
    && sh -c 'echo "deb http://packages.ros.org/ros-testing/ubuntu/ xenial main" > /etc/apt/sources.list.d/ros-testing.list' \
    && apt-get update && apt-get -y --no-install-recommends install \
        ros-kinetic-gazebo-ros-pkgs \
        ros-kinetic-mavros          \
        ros-kinetic-mavros-extras   \
        ros-kinetic-ros-base        \
        ros-kinetic-rviz            \
        ros-kinetic-tf2             \
        ros-kinetic-cv-bridge       \
    && apt-get -y autoremove        \
    && apt-get clean autoclean      \
    && rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*

# Initialize ROS
RUN geographiclib-get-geoids egm96-5 \
    && rosdep init                   \
    && rosdep update

RUN echo 'source /opt/ros/kinetic/setup.bash' >> ${HOME}/.bashrc

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

# Setup catkin workspace
ENV CATKIN_WS ${HOME}/catkin_ws
COPY docker/init_workspace.sh ${HOME}
RUN ${HOME}/init_workspace.sh

ENV CCACHE_CPP2=1
ENV CCACHE_MAXSIZE=1G
ENV DISPLAY :0
ENV TERM=xterm
# Some QT-Apps don't not show controls without this
ENV QT_X11_NO_MITSHM 1

COPY requirements.txt ${HOME}
RUN pip install --no-cache-dir -r requirements.txt
