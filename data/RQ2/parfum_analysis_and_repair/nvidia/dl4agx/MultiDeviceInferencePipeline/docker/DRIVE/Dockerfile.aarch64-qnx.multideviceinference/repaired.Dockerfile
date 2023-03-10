#############################################################################
# Copyright (c) 2018-2019 NVIDIA Corporation. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# File: DL4AGX/MultiDeviceInferencePipeline/docker/DRIVE/Dockerfile.aarch64-qnx.multideviceinference
# Description: Docker image for MultiDeviceInferencePipeline for DRIVE aarch64-qnx
############################################################################
ARG BASE_PDK_IMAGE=nvidia/drive_os_pdk:5.1.6.0-qnx
FROM $BASE_PDK_IMAGE

WORKDIR /
# CMake
RUN CMAKE_VERSION=3.15 && \
    CMAKE_BUILD=3.15.0 && \
    curl -f -L https://cmake.org/files/v${CMAKE_VERSION}/cmake-${CMAKE_BUILD}.tar.gz | tar -xzf - && \
    cd /cmake-${CMAKE_BUILD} && \
    ./bootstrap --parallel=$(grep ^processor /proc/cpuinfo | wc -l) && \
    make -j"$(grep ^processor /proc/cpuinfo | wc -l)" install && \
    rm -rf /cmake-${CMAKE_BUILD}

RUN rm -rf /usr/aarch64-unknown-nto-qnx/aarch64le/lib/libjpeg.so.* && \
    rm -rf /usr/aarch64-unknown-nto-qnx/usr/include/j* && \
    rm -rf /usr/aarch64-unknown-nto-qnx/x86 /usr/aarch64-unknown-nto-qnx/x86_64 && \
    rm -rf /usr/lib/x86_64-linux-gnu/libjpeg.* && \
    rm -rf /usr/local/lib/libjpeg.*

# protobuf
ENV PROTOBUF_VERSION=3.5.1
RUN curl -f -L https://github.com/google/protobuf/releases/download/v${PROTOBUF_VERSION}/protobuf-all-${PROTOBUF_VERSION}.tar.gz | tar -xzf -

RUN cd /protobuf-${PROTOBUF_VERSION} && \
    ./autogen.sh && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" CXXFLAGS="-fPIC" --prefix=/usr/local --disable-shared 2>&1 > /dev/null && \
    make -j"$(grep ^processor /proc/cpuinfo | wc -l)" install 2>&1 > /dev/null && \
    make clean

RUN cd /protobuf-${PROTOBUF_VERSION} \
    && ./autogen.sh && ./configure \
    CC=$QNX_HOST/usr/bin/aarch64-unknown-nto-qnx7.0.0-gcc \
    CXX=$QNX_HOST/usr/bin/aarch64-unknown-nto-qnx7.0.0-g++ \
    CXXFLAGS="-fPIC -D__EXT_POSIX1_198808 -I$QNX_TARGET/usr/include -I$QNX_TARGET/usr/include/aarch64 -I$QNX_TARGET/usr/include/c++/v1 -L$QNX_TARGET/aarch64le/lib -D_POSIX_C_SOURCE=200112L -D_QNX_SOURCE -D_FILE_OFFSET_BITS=64" \
      --host=aarch64-unknown-nto-qnx7.0.0 \
      --build=x86_64-linux-gnu \
      --with-sysroot=$QNX_TARGET \
      --prefix=/usr/aarch64-unknown-nto-qnx/aarch64le \
      --with-protoc=/usr/local/bin/protoc && make -j$(nproc) install && \
    make clean

ENV JPEG_TURBO_VERSION=1.5.3
RUN curl -f -L https://github.com/libjpeg-turbo/libjpeg-turbo/archive/${JPEG_TURBO_VERSION}.tar.gz | tar -xzf -

RUN cd /libjpeg-turbo-${JPEG_TURBO_VERSION} && \
    autoreconf -fiv && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
      --enable-shared \
      --prefix=/usr/local/ && \
    make -j"$(grep ^processor /proc/cpuinfo | wc -l)" install && \
    make clean

RUN cd /libjpeg-turbo-${JPEG_TURBO_VERSION} && \
    autoreconf -fiv && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
      --enable-shared \
      CC=aarch64-unknown-nto-qnx7.0.0-gcc \
      CXX=aarch64-unknown-nto-qnx7.0.0-g++ \
      --host=aarch64-unknown-nto-qnx7.0.0 \
      --prefix=/usr/aarch64-unknown-nto-qnx/aarch64le && \
    make -j"$(grep ^processor /proc/cpuinfo | wc -l)" install && \
    make clean

RUN rm -rf /libjpeg-turbo-${JPEG_TURBO_VERSION}


ENV FFMPEG_VERSION=3.4.2
RUN cd /tmp && wget https://developer.download.nvidia.com/compute/redist/nvidia-dali/ffmpeg-${FFMPEG_VERSION}.tar.bz2 && \
    tar xf ffmpeg-$FFMPEG_VERSION.tar.bz2 && \
    rm ffmpeg-$FFMPEG_VERSION.tar.bz2

RUN cd /tmp/ffmpeg-$FFMPEG_VERSION && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
      --target_os=linux \
      --prefix=/usr/local/ \
      --disable-static \
      --disable-all \
      --disable-autodetect \
      --disable-iconv \
      --enable-shared \
      --enable-avformat \
      --enable-avcodec \
      --enable-avfilter \
      --enable-protocol=file \
      --enable-demuxer=mov,matroska \
      --enable-bsf=h264_mp4toannexb,hevc_mp4toannexb \
      --disable-stripping \
      --extra-cflags="-D_XOPEN_SOURCE=600 -std=gnu99 -fPIC" && \
    make -j"$(grep ^processor /proc/cpuinfo | wc -l)" && make install && \
    make clean

RUN cd /tmp/ffmpeg-$FFMPEG_VERSION && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
      --arch=aarch64 \
      --target_os=qnx \
      --prefix=/usr/aarch64-unknown-nto-qnx/aarch64le/ \
      --disable-static \
      --disable-all \
      --disable-autodetect \
      --disable-iconv \
      --enable-shared \
      --enable-avformat \
      --enable-avcodec \
      --enable-avfilter \
      --enable-protocol=file \
      --enable-cross-compile \
      --enable-demuxer=mov,matroska \
      --enable-bsf=h264_mp4toannexb,hevc_mp4toannexb \
      --cc=aarch64-unknown-nto-qnx7.0.0-gcc \
      --cxx=aarch64-unknown-nto-qnx7.0.0-g++ \
      --disable-stripping \
      --extra-cflags="-D_XOPEN_SOURCE=600 -std=gnu99 -fPIC" && \
    make -j"$(grep ^processor /proc/cpuinfo | wc -l)" && make install && \
    make clean

ENV OPENCV_VERSION=3.4.3
RUN curl -f -L https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.tar.gz | tar -xzf -

RUN cd /opencv-${OPENCV_VERSION} && mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_INSTALL_PREFIX=/usr/local/ \
          -DBUILD_LIST=core,improc,imgcodecs \
          -DBUILD_PNG=ON \
          -DBUILD_TIFF=OFF \
          -DBUILD_TBB=OFF \
          -DBUILD_WEBP=OFF \
          -DBUILD_JPEG=ON \
          -DBUILD_JASPER=OFF \
          -DBUILD_ZLIB=ON \
          -DBUILD_EXAMPLES=OFF \
          -DBUILD_FFMPEG=ON \
          -DBUILD_opencv_java=OFF \
          -DBUILD_opencv_python2=OFF \
          -DBUILD_opencv_python3=OFF \
          -DENABLE_NEON=OFF \
          -DWITH_PROTOBUF=OFF \
          -DWITH_PTHREADS_PF=OFF \
          -DWITH_OPENCL=OFF \
          -DWITH_OPENMP=OFF \
          -DWITH_FFMPEG=OFF \
          -DWITH_GSTREAMER=OFF \
          -DWITH_GSTREAMER_0_10=OFF \
          -DWITH_CUDA=OFF \
          -DWITH_GTK=OFF \
          -DWITH_VTK=OFF \
          -DWITH_TBB=OFF \
          -DWITH_1394=OFF \
          -DWITH_OPENEXR=OFF \
          -DINSTALL_C_EXAMPLES=OFF \
          -DINSTALL_TESTS=OFF \
          VERBOSE=1 ../  && \
    make -j"$(grep ^processor /proc/cpuinfo | wc -l)" install && \
    cd .. && rm -rf build

ENV DALI_TAG_VERSION=v0.14.0-rc1
RUN git clone https://github.com/NVIDIA/DALI.git --recursive && cd DALI && git checkout $DALI_TAG_VERSION && git submodule update --init --recursive && cp docker/opencv-qnx.patch /opencv-qnx.patch
RUN cd /opencv-${OPENCV_VERSION} && git apply /opencv-qnx.patch\
      && mkdir build && cd build && \
      cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DVIBRANTE_PDK:STRING=/ \
        -DCMAKE_TOOLCHAIN_FILE=$PWD/../platforms/qnx/aarch64-qnx.toolchain.cmake \
        -DCMAKE_INSTALL_PREFIX=/usr/aarch64-unknown-nto-qnx/aarch64le  \
        -DBUILD_LIST=core,improc,imgcodecs \
        -DBUILD_PNG=ON \
        -DBUILD_TIFF=OFF \
        -DBUILD_TBB=OFF \
        -DBUILD_WEBP=OFF \
        -DBUILD_JPEG=ON \
        -DBUILD_JASPER=OFF \
        -DBUILD_ZLIB=ON \
        -DBUILD_EXAMPLES=OFF \
        -DBUILD_FFMPEG=ON \
        -DBUILD_opencv_java=OFF \
        -DBUILD_opencv_python2=OFF \
        -DBUILD_opencv_python3=OFF \
        -DENABLE_NEON=OFF \
        -DWITH_PROTOBUF=OFF \
        -DWITH_PTHREADS_PF=OFF \
        -DWITH_OPENCL=OFF \
        -DWITH_OPENMP=OFF \
        -DWITH_FFMPEG=OFF \
        -DWITH_GSTREAMER=OFF \
        -DWITH_GSTREAMER_0_10=OFF \
        -DWITH_CUDA=OFF \
        -DWITH_GTK=OFF \
        -DWITH_VTK=OFF \
        -DWITH_TBB=OFF \
        -DWITH_1394=OFF \
        -DWITH_OPENEXR=OFF \
        -DINSTALL_C_EXAMPLES=OFF \
        -DINSTALL_TESTS=OFF \
        -DVIBRANTE=TRUE \
        VERBOSE=1 \
    ../ && \
    make -j"$(grep ^processor /proc/cpuinfo | wc -l)" install && \
    cd .. && rm -rf build

RUN BOOST_VERSION=1_66_0 \
    && cd /usr/local \
    && curl -f -L https://dl.bintray.com/boostorg/release/1.66.0/source/boost_${BOOST_VERSION}.tar.gz | tar -xzf - \
    && cp -r  boost_${BOOST_VERSION}/boost  /usr/include/boost \
    && cp -r  boost_${BOOST_VERSION}/boost  /usr/aarch64-unknown-nto-qnx/aarch64le/include/boost \
    && rm -rf boost_${BOOST_VERSION}

RUN rm -rf /opencv-${OPENCV_VERSION}

RUN cd /tmp && rm -rf ffmpeg-$FFMPEG_VERSION

ENV PATH=/usr/local/cuda-${CUDA_VERSION}/bin:$PATH

RUN cd DALI && mkdir -p build && cd build && cmake \
      -DCMAKE_INSTALL_PREFIX=./install \
      -DCMAKE_COLOR_MAKEFILE=ON \
      -DBUILD_NVJPEG=OFF \
      -DBUILD_NVOF=OFF \
      -DBUILD_TENSORFLOW=OFF \
      -DBUILD_TEST=OFF \
      -DBUILD_JPEG_TURBO=ON \
      -DJPEG_INCLUDE_DIR=/usr/local/include \
      -DJPEG_LIBRARY=/usr/local/lib \
      -DBUILD_PYTHON=OFF \
      -DBUILD_LMDB=OFF \
      -DBUILD_NVTX=OFF \
      -DBUILD_BENCHMARK=OFF \
      -DOPENCV_PATH=/usr/local/ \
      -DFFMPEG_ROOT_DIR=/usr/local/ \
      -DProtobuf_LIBRARIES=/usr/local/lib \
      -DFFMPEG_ROOT_DIR=/usr/local/ \
      ../ && make -j"$(grep ^processor /proc/cpuinfo | wc -l)" install && \
    cp dali/python/nvidia/dali/libdali.so /usr/local/lib/ && \
    rsync -a  dali/python/nvidia/dali/include /usr/local/ && \
    rsync -a install/include /usr/local/ && \
    rm -rf build

RUN rm -f /usr/aarch64-unknown-nto-qnx/aarch64le/bin/protoc
RUN ln -sf /usr/local/bin/protoc /usr/aarch64-unknown-nto-qnx/aarch64le/bin/protoc

RUN find / -name libprotobuf.*
RUN find / -name libjpeg.*

RUN cd DALI && mkdir -p build_aarch64-qnx && cd build_aarch64-qnx && cmake \
      -DCMAKE_PREFIX_PATH=/usr/aarch64-unknown-nto-qnx/aarch64le \
      -DCMAKE_INSTALL_PREFIX=./install \
      -DARCH=aarch64-qnx \
      -DBUILD_NVJPEG=OFF \
      -DBUILD_NVML=OFF \
      -DBUILD_TENSORFLOW=OFF \
      -DBUILD_TEST=OFF \
      -DBUILD_JPEG_TURBO=ON \
      -DBUILD_PYTHON=OFF \
      -DBUILD_LMDB=OFF \
      -DBUILD_NVOF=OFF \
      -DBUILD_NVTX=OFF \
      -DBUILD_NVML=OFF \
      -DCMAKE_TOOLCHAIN_FILE:STRING="$PWD/../platforms/qnx/aarch64-qnx.toolchain.cmake" \
      -DBUILD_BENCHMARK=OFF \
      -DCUDA_HOST=/usr/local/cuda-${CUDA_VERSION} \
      -DCUDA_TARGET=/usr/local/cuda-${CUDA_VERSION}/targets/aarch64-qnx \
      -DCXXFLAGS="-fPIC" \
      ../ && make -j"$(grep ^processor /proc/cpuinfo | wc -l)" install VERBOSE=1  && \
    cp dali/python/nvidia/dali/libdali.so /usr/aarch64-unknown-nto-qnx/aarch64le/lib/ && \
    rsync -a  dali/python/nvidia/dali/include /usr/aarch64-unknown-nto-qnx/aarch64le && \
    rsync -a install/include /usr/aarch64-unknown-nto-qnx/aarch64le && \
    rm -rf build

RUN rm -rf DALI

RUN cd /protobuf-${PROTOBUF_VERSION} && \
    ./autogen.sh && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" CXXFLAGS="-fPIC" --prefix=/usr/local 2>&1 > /dev/null && \
    make -j"$(grep ^processor /proc/cpuinfo | wc -l)" install 2>&1 > /dev/null && \
    make clean

RUN rm -rf /protobuf-${PROTOBUF_VERSION}
