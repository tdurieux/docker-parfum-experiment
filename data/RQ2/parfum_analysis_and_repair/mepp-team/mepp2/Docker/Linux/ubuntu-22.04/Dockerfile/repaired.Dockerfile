# How to build the image
# docker build -t ubuntu-22.04-mepp2 .

# How to start a container in interactive mode
# docker run -it ubuntu-22.04-mepp2

FROM ubuntu:22.04

# Author
MAINTAINER Martial TOLA

# Metadata
LABEL version="1.0"
LABEL vendor="LIRIS"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get clean
RUN apt-get update

RUN apt-get -y --no-install-recommends install vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install unzip && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install build-essential gdb cgdb && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install clang && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install valgrind && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install xvfb && rm -rf /var/lib/apt/lists/*;

# CMake
RUN apt-get -y --no-install-recommends install cmake cmake-curses-gui && rm -rf /var/lib/apt/lists/*; # 3.22.1

# Boost
RUN apt-get -y --no-install-recommends install libboost-all-dev && rm -rf /var/lib/apt/lists/*; # 1.74.0

# Eigen 3
RUN apt-get -y --no-install-recommends install libeigen3-dev && rm -rf /var/lib/apt/lists/*; # 3.4.0

# CGAL
RUN apt-get -y --no-install-recommends install libgmp-dev libmpfr-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libcgal-dev && rm -rf /var/lib/apt/lists/*; # 5.4

# OpenMesh (installation in user home directory)
RUN cd /tmp                                                                                         && \
    wget https://www.graphics.rwth-aachen.de/media/openmesh_static/Releases/7.1/OpenMesh-7.1.tar.gz && \
    tar -xzf OpenMesh-7.1.tar.gz                                                                    && \
    cd OpenMesh-7.1 && mkdir build && cd build                                                      && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$HOME/OpenMesh-7.1 ..                   && \
    make -j 3                                                                                       && \
    make install && cd && rm OpenMesh-7.1.tar.gz
RUN cd /tmp                                                                                         && \
    wget https://www.graphics.rwth-aachen.de/media/openmesh_static/Releases/8.1/OpenMesh-8.1.tar.gz && \
    tar -xzf OpenMesh-8.1.tar.gz                                                                    && \
    cd OpenMesh-8.1 && mkdir build && cd build                                                      && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$HOME/OpenMesh-8.1 ..                   && \
    make -j 3                                                                                       && \
    make install && cd && rm OpenMesh-8.1.tar.gz
RUN cd /tmp                                                                                         && \
    wget https://www.graphics.rwth-aachen.de/media/openmesh_static/Releases/9.0/OpenMesh-9.0.tar.gz && \
    tar -xzf OpenMesh-9.0.tar.gz                                                                    && \
    cd OpenMesh-9.0.0 && mkdir build && cd build                                                    && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$HOME/OpenMesh-9.0.0 ..                 && \
    make -j 3                                                                                       && \
    make install && cd && rm OpenMesh-9.0.tar.gz

# Qt4
#RUN apt-get -y install libqt4-dev libqt4-opengl-dev # now, no more Qt4 in Ubuntu
# Qt5
RUN apt-get -y --no-install-recommends install qtbase5-dev libqt5opengl5-dev && rm -rf /var/lib/apt/lists/*; # 5.15.3

# OpenSceneGraph
RUN apt-get -y --no-install-recommends install libjpeg-dev libpng-dev libtiff-dev libfreetype6-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libopenscenegraph-dev && rm -rf /var/lib/apt/lists/*; # 3.6.5

# Doxygen and Graphviz
RUN apt-get -y --no-install-recommends install doxygen graphviz && rm -rf /var/lib/apt/lists/*;

# VTK
#RUN apt-get -y install libvtk7-dev # 7.1.1
RUN apt-get -y --no-install-recommends install libvtk9-dev && rm -rf /var/lib/apt/lists/*; # 9.1.0

# PCL - 3 tests fail with 1.12.1 but are OK with 1.11.1 and 1.10.1 !
RUN apt-get -y --no-install-recommends install libflann-dev libproj-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libpcl-dev && rm -rf /var/lib/apt/lists/*; # 1.12.1

# FBX SDK
RUN mkdir ~/FBX_SDK && mkdir ~/FBX_SDK/2019.0                                         && \
    cd /tmp && \
    wget https://download.autodesk.com/us/fbx/2019/2019.0/fbx20190_fbxsdk_linux.tar.gz && \
    tar -xzf fbx20190_fbxsdk_linux.tar.gz && \
    yes yes | ./fbx20190_fbxsdk_linux ~/FBX_SDK/2019.0 && \
    ln -s ~/FBX_SDK/2019.0/lib/gcc4/x64/release ~/FBX_SDK/2019.0/lib/release && \
    ln -s ~/FBX_SDK/2019.0/lib/gcc4/x64/debug ~/FBX_SDK/2019.0/lib/debug && \
    cd && rm fbx20190_fbxsdk_linux.tar.gz

# Draco
RUN apt-get -y --no-install-recommends install libdraco-dev && rm -rf /var/lib/apt/lists/*; # 1.5.2

# Cleanup
RUN apt-get -y autoremove

ENV HOME /root

# App environment
#ENV OPENMESH_DIR "$HOME/OpenMesh-7.1"
#ENV OPENMESH_DIR "$HOME/OpenMesh-8.1"
ENV OPENMESH_DIR "$HOME/OpenMesh-9.0.0"

ENV FBX_DIR "$HOME/FBX_SDK/2019.0"

# Qt6
#RUN apt-get -y install qt6-base-dev libqt6opengl6-dev # 6.2.4
