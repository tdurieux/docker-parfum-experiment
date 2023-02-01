# How to build the image
# docker build -t ubuntu-22.04-cgal_5.x.y-pcl_1.1x.y-mepp2 .

# How to start a container in interactive mode
# docker run -it ubuntu-22.04-cgal_5.x.y-pcl_1.1x.y-mepp2

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

# CGAL (installation in user home directory)
RUN apt-get -y --no-install-recommends install libgmp-dev libmpfr-dev && rm -rf /var/lib/apt/lists/*;
#RUN apt-get -y install libcgal-dev # 5.4
RUN cd /tmp                                                                                         && \
    wget https://github.com/CGAL/cgal/releases/download/releases%2FCGAL-4.14.3/CGAL-4.14.3.zip      && \
    cd && unzip /tmp/CGAL-4.14.3.zip
RUN cd /tmp                                                                                         && \
    wget https://github.com/CGAL/cgal/releases/download/v5.0.4/CGAL-5.0.4.zip                       && \
    cd && unzip /tmp/CGAL-5.0.4.zip
RUN cd /tmp                                                                                         && \
    wget https://github.com/CGAL/cgal/releases/download/v5.1.5/CGAL-5.1.5.zip                       && \
    cd && unzip /tmp/CGAL-5.1.5.zip
RUN cd /tmp                                                                                         && \
    wget https://github.com/CGAL/cgal/releases/download/v5.2.3/CGAL-5.2.3.zip                       && \
    cd && unzip /tmp/CGAL-5.2.3.zip
RUN cd /tmp                                                                                         && \
    wget https://github.com/CGAL/cgal/releases/download/v5.2.4/CGAL-5.2.4.zip                       && \
    cd && unzip /tmp/CGAL-5.2.4.zip
RUN cd /tmp                                                                                         && \
    wget https://github.com/CGAL/cgal/releases/download/v5.3.2/CGAL-5.3.2.zip                       && \
    cd && unzip /tmp/CGAL-5.3.2.zip
RUN cd /tmp                                                                                         && \
    wget https://github.com/CGAL/cgal/releases/download/v5.4/CGAL-5.4.zip                           && \
    cd && unzip /tmp/CGAL-5.4.zip
RUN cd /tmp                                                                                         && \
    wget https://github.com/CGAL/cgal/releases/download/v5.4.1/CGAL-5.4.1.zip                       && \
    cd && unzip /tmp/CGAL-5.4.1.zip

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

# PCL (installation in user home directory) - DON'T use libpcl-dev package ?!
RUN apt-get -y --no-install-recommends install libflann-dev libproj-dev && rm -rf /var/lib/apt/lists/*;
#RUN apt-get -y install libpcl-dev # 1.12.1
#RUN cd /tmp                                                                                                                                                                && \
#    wget https://github.com/PointCloudLibrary/pcl/archive/refs/tags/pcl-1.9.1.tar.gz                                                                                       && \
#    tar -xzf pcl-1.9.1.tar.gz                                                                                                                                              && \
#    cd pcl-pcl-1.9.1 && mkdir build && cd build                                                                                                                            && \
#    cmake -DCMAKE_BUILD_TYPE=Release -DPCL_ENABLE_SSE=OFF -DPCL_ONLY_CORE_POINT_TYPES=ON -DBUILD_global_tests=OFF -DWITH_VTK=OFF -DCMAKE_INSTALL_PREFIX=$HOME/pcl-1.9.1 .. && \
#    make -j 3                                                                                                                                                              && \
#    make install && cd
RUN cd /tmp                                                                                                                                                                 && \
    wget https://github.com/PointCloudLibrary/pcl/archive/refs/tags/pcl-1.10.1.tar.gz                                                                                       && \
    tar -xzf pcl-1.10.1.tar.gz                                                                                                                                              && \
    cd pcl-pcl-1.10.1 && mkdir build && cd build                                                                                                                            && \
    cmake -DCMAKE_BUILD_TYPE=Release -DPCL_ENABLE_SSE=OFF -DPCL_ONLY_CORE_POINT_TYPES=ON -DBUILD_global_tests=OFF -DWITH_VTK=OFF -DCMAKE_INSTALL_PREFIX=$HOME/pcl-1.10.1 .. && \
    make -j 3                                                                                                                                                               && \
    make install && cd && rm pcl-1.10.1.tar.gz
RUN cd /tmp                                                                                                                                                                 && \
    wget https://github.com/PointCloudLibrary/pcl/archive/refs/tags/pcl-1.11.1.tar.gz                                                                                       && \
    tar -xzf pcl-1.11.1.tar.gz                                                                                                                                              && \
    cd pcl-pcl-1.11.1 && mkdir build && cd build                                                                                                                            && \
    cmake -DCMAKE_BUILD_TYPE=Release -DPCL_ENABLE_SSE=OFF -DPCL_ONLY_CORE_POINT_TYPES=ON -DBUILD_global_tests=OFF -DWITH_VTK=OFF -DCMAKE_INSTALL_PREFIX=$HOME/pcl-1.11.1 .. && \
    make -j 3                                                                                                                                                               && \
    make install && cd && rm pcl-1.11.1.tar.gz
RUN cd /tmp                                                                                                                                                                 && \
    wget https://github.com/PointCloudLibrary/pcl/archive/refs/tags/pcl-1.12.1.tar.gz                                                                                       && \
    tar -xzf pcl-1.12.1.tar.gz                                                                                                                                              && \
    cd pcl-pcl-1.12.1 && mkdir build && cd build                                                                                                                            && \
    cmake -DCMAKE_BUILD_TYPE=Release -DPCL_ENABLE_SSE=OFF -DPCL_ONLY_CORE_POINT_TYPES=ON -DBUILD_global_tests=OFF -DWITH_VTK=OFF -DCMAKE_INSTALL_PREFIX=$HOME/pcl-1.12.1 .. && \
    make -j 3                                                                                                                                                               && \
    make install && cd && rm pcl-1.12.1.tar.gz

# FBX SDK
RUN mkdir ~/FBX_SDK && mkdir ~/FBX_SDK/2019.0                                         && \
    cd /tmp && \
    wget https://download.autodesk.com/us/fbx/2019/2019.0/fbx20190_fbxsdk_linux.tar.gz && \
    tar -xzf fbx20190_fbxsdk_linux.tar.gz && \
    yes yes | ./fbx20190_fbxsdk_linux ~/FBX_SDK/2019.0 && \
    ln -s ~/FBX_SDK/2019.0/lib/gcc4/x64/release ~/FBX_SDK/2019.0/lib/release && \
    ln -s ~/FBX_SDK/2019.0/lib/gcc4/x64/debug ~/FBX_SDK/2019.0/lib/debug && \
    cd && rm fbx20190_fbxsdk_linux.tar.gz

# Draco (installation in user home directory)
#RUN apt-get -y install libdraco-dev # 1.5.2
#RUN cd /tmp                                                                                             && \
#    wget https://github.com/google/draco/archive/refs/tags/1.3.6.tar.gz                                 && \
#    tar -xzf 1.3.6.tar.gz                                                                               && \
#    cd draco-1.3.6 && mkdir build && cd build                                                           && \
#    cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=$HOME/draco-1.3.6 .. && \
#    make -j 3                                                                                           && \
#    make install && cd
RUN cd /tmp                                                                                             && \
    wget https://github.com/google/draco/archive/refs/tags/1.4.3.tar.gz                                 && \
    tar -xzf 1.4.3.tar.gz                                                                               && \
    cd draco-1.4.3 && mkdir build && cd build                                                           && \
    cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=$HOME/draco-1.4.3 .. && \
    make -j 3                                                                                           && \
    make install && cd && rm 1.4.3.tar.gz
RUN cd /tmp                                                                                             && \
    wget https://github.com/google/draco/archive/refs/tags/1.5.2.tar.gz                                 && \
    tar -xzf 1.5.2.tar.gz                                                                               && \
    cd draco-1.5.2 && mkdir build && cd build                                                           && \
    cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=$HOME/draco-1.5.2 .. && \
    make -j 3                                                                                           && \
    make install && cd && rm 1.5.2.tar.gz

# Cleanup
RUN apt-get -y autoremove

ENV HOME /root

# App environment
#ENV CGAL_DIR "$HOME/CGAL-4.14.3"
#ENV CGAL_DIR "$HOME/CGAL-5.0.4"
#ENV CGAL_DIR "$HOME/CGAL-5.1.5"
ENV CGAL_DIR "$HOME/CGAL-5.2.3"
#ENV CGAL_DIR "$HOME/CGAL-5.2.4"
#ENV CGAL_DIR "$HOME/CGAL-5.3.2"
#ENV CGAL_DIR "$HOME/CGAL-5.4"
#ENV CGAL_DIR "$HOME/CGAL-5.4.1"

#ENV OPENMESH_DIR "$HOME/OpenMesh-7.1"
#ENV OPENMESH_DIR "$HOME/OpenMesh-8.1"
ENV OPENMESH_DIR "$HOME/OpenMesh-9.0.0"

#ENV PCL_DIR "$HOME/pcl-1.9.1/share/pcl-1.9"
#ENV PCL_DIR "$HOME/pcl-1.10.1/share/pcl-1.10"
#ENV PCL_DIR "$HOME/pcl-1.11.1/share/pcl-1.11"
ENV PCL_DIR "$HOME/pcl-1.12.1/share/pcl-1.12"

ENV FBX_DIR "$HOME/FBX_SDK/2019.0"

#ENV DRACO_DIR "$HOME/draco-1.3.6"
#ENV DRACO_DIR "$HOME/draco-1.4.3"
ENV DRACO_DIR "$HOME/draco-1.5.2"

# Qt6
#RUN apt-get -y install qt6-base-dev libqt6opengl6-dev # 6.2.4
