##########################################################################
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
# File: //LeNetWithS3Pooling/docker/Dockerfile.x86_64-linux.LeNetWithS3Pooling
# Description: Dockerfile to support S3Pooling app
##########################################################################
FROM nvidia/drive_os_pdk:5.1.6.0-linux

COPY TensorRT-6.0.1.8.Ubuntu-18.04.x86_64-gnu.cuda-10.2.cudnn7.6.tar.gz tensorrt6.tar.gz

RUN tar xvf tensorrt6.tar.gz && rm -rf tensorrt6.tar.gz

RUN mv /usr/local/cuda-10.2/dl/targets/x86_64-linux/include/cudnn.h / && \
    rm -rf /usr/local/cuda-10.2/dl/targets/x86_64-linux/include && \
    mv /TensorRT-6.0.1.8/include /usr/local/cuda-10.2/dl/targets/x86_64-linux/include && \
    mv /cudnn.h /usr/local/cuda-10.2/dl/targets/x86_64-linux/include/

RUN mv /usr/local/cuda-10.2/dl/targets/x86_64-linux/lib/libcudnn* /  && \
    rm -rf /usr/local/cuda-10.2/dl/targets/x86_64-linux/lib && \
    mv /TensorRT-6.0.1.8/targets/x86_64-linux-gnu/lib /usr/local/cuda-10.2/dl/targets/x86_64-linux/lib && \
    mv /libcudnn* /usr/local/cuda-10.2/dl/targets/x86_64-linux/lib

RUN rm -rf /TensorRT-6.0.1.8

RUN apt-get update \
    && apt-get install --no-install-recommends -y libssl-dev \
    && rm -rf /var/lib/apt/lists/* \
    && wget https://curl.haxx.se/download/curl-7.67.0.tar.gz \
    && tar xvf curl-7.67.0.tar.gz \
    && cd curl-7.67.0 \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-ssl \
    && make \
    && make install && rm curl-7.67.0.tar.gz

RUN CMAKE_VERSION=3.15 && \
    CMAKE_BUILD=3.15.0 && \
    curl -f -L https://cmake.org/files/v${CMAKE_VERSION}/cmake-${CMAKE_BUILD}.tar.gz | tar -xzf - && \
    cd /cmake-${CMAKE_BUILD} && \
    ./bootstrap --parallel=$(grep ^processor /proc/cpuinfo | wc -l) && \
    make -j"$(grep ^processor /proc/cpuinfo | wc -l)" install && \
    rm -rf /cmake-${CMAKE_BUILD}

RUN cp /usr/local/cuda-10.2/dl/targets/x86_64-linux/lib/libcudnn.so.7.5.1 /usr/local/cuda-10.2/dl/targets/x86_64-linux/lib64/ && \
    cp /usr/local/cuda-10.2/dl/targets/x86_64-linux/lib/libcudnn.so.7.5.1 /usr/lib/x86_64-linux-gnu/

RUN git clone -b master https://github.com/nvidia/TensorRT TensorRT -b release/6.0 && \
    cd TensorRT && \
    git submodule update --init --recursive && \
    export TRT_SOURCE=`pwd` && \
    export TRT_RELEASE=/usr/local/cuda-10.2/dl/targets/x86_64-linux/lib && \
    cd parsers/onnx && \
    git checkout webinar/s3pool

RUN cd /TensorRT && mkdir -p build && cd build && \
    cmake .. -DTRT_LIB_DIR=/usr/local/cuda-10.2/dl/targets/x86_64-linux/lib \
             -DTRT_BIN_DIR=`pwd`/out \
             -DCUDNN_ROOT_DIR=/usr/local/cuda-10.2/dl/targets/x86_64-linux/ \
             -DBUILD_SAMPLES=OFF \
             -DPROTOBUF_VERSION=3.8.0 && \
    make -j$(nproc) && \
    cd out && \
    cp lib* /usr/local/cuda-10.2/dl/targets/x86_64-linux/lib

RUN rm -rf curl-7.67.0 curl-7.67.0.tar.gz TensorRT
