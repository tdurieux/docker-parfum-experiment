ARG CUDA_VERSION
ARG TF_VERSION
ARG BAZEL_VERSION
ARG CUB_VERSION
ARG OPENCV_VERSION
FROM tensorflow:ubuntu16.04-cuda${CUDA_VERSION}-bazel${BAZEL_VERSION}-tensorflow${TF_VERSION}
LABEL maintainer="Patrick Wieschollek <mail@patwie.com>"

ARG TF_VERSION
ARG BAZEL_VERSION
ARG CUB_VERSION
ARG OPENCV_VERSION


RUN apt-get -y update
RUN apt-get -y install python2.7 python3.5 python3.5-dev wget unzip \
                       pkg-config libatlas-base-dev gfortran \
                       libjasper-dev libgtk2.0-dev libavcodec-dev libavformat-dev \
                       libswscale-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libv4l-dev \
                       python-numpy python3-pip \
                       libhdf5-10 libhdf5-serial-dev libhdf5-dev libhdf5-cpp-11


WORKDIR /tmp
RUN wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip -O opencv3.zip
RUN dir
RUN unzip -q opencv3.zip
RUN dir
RUN mv opencv-${OPENCV_VERSION} /opencv
# RUN wget https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip -O opencv_contrib3.zip
# RUN unzip -q opencv_contrib3.zip
# RUN mv opencv_contrib-${OPENCV_VERSION} /opencv_contrib
RUN mkdir -p /opencv/build
WORKDIR /opencv/build

RUN pip3 install -U numpy
#RUN pip3 install numpy
ENV PYTHON_INCLUDE_DIR=/usr/include/python2.7
ENV PYTHON_LIBRARY=/usr/lib/python2.7/config/libpython2.7.so

RUN echo "find_package(HDF5)" >> /opencv/modules/python/common.cmake
RUN echo "include_directories(${HDF5_INCLUDE_DIRS})" >> /opencv/modules/python/common.cmake

RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
        -D BUILD_PYTHON_SUPPORT=OFF \
        -D WITH_CUDA=OFF \
        -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D INSTALL_C_EXAMPLES=OFF \
        -D INSTALL_PYTHON_EXAMPLES=OFF \
        #-D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib/modules \
        -D BUILD_EXAMPLES=OFF \
        -D BUILD_NEW_PYTHON_SUPPORT=OFF \
        -D WITH_IPP=OFF \
        -D WITH_V4L=ON ..
RUN make -j
RUN make install
RUN ldconfig


WORKDIR /root
