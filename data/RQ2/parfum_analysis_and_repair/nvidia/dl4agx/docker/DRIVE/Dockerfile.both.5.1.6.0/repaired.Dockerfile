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
# File: DL4AGX/docker/DRIVE/Dockerfile.both.5.1.6.0
# Description: Docker image for DRIVE PDK 5.1.6.0 for aarch64 and QNX
############################################################################
FROM nvidia/cuda:10.1-devel-ubuntu18.04

ARG base_os_version=1804
ARG pdk_version=5.1.6.0

ENV CUDA_VERSION=10.2  
ARG cuda_version_dash=10-2
ARG cuda_version_long=10.2.19
ARG driver_version=430.17

ARG cudnn_version=7.5
ARG cudnn_version_long=7.5.1.14

ARG trt_version=5.1
ARG trt_version_short=5.1.4
ARG trt_version_long=5.1.4.2
ARG target_driver=10.2-r430

ARG cuda_repo_x86_64=cuda-repo-ubuntu${base_os_version}-${cuda_version_dash}-local-${cuda_version_long}-${driver_version}_1.0-1_amd64.deb
ARG cuda_repo_cross_aarch64_linux=cuda-repo-cross-aarch64-${cuda_version_dash}-local-${cuda_version_long}_1.0-1_all.deb
ARG cuda_repo_cross_aarch64_qnx=cuda-repo-cross-qnx-${cuda_version_dash}-local-${cuda_version_long}_1.0-1_all.deb

ENV CUDNN_x86_64_DEBS="libcudnn7_${cudnn_version_long}-1+cuda${CUDA_VERSION}_amd64.deb \
                       libcudnn7-dev_${cudnn_version_long}-1+cuda${CUDA_VERSION}_amd64.deb"

ENV CUDNN_AARCH64_LINUX_DEBS="libcudnn7-cross-aarch64_${cudnn_version_long}-1+cuda${CUDA_VERSION}_all.deb \
                              libcudnn7-dev-cross-aarch64_${cudnn_version_long}-1+cuda${CUDA_VERSION}_all.deb"

ENV CUDNN_AARCH64_QNX_DEBS="libcudnn7-cross-qnx_${cudnn_version_long}-1+cuda${CUDA_VERSION}_all.deb \
                        libcudnn7-dev-cross-qnx_${cudnn_version_long}-1+cuda${CUDA_VERSION}_all.deb"

ENV tensorrt_x86_64_repo="nv-tensorrt-repo-ubuntu${base_os_version}-cuda${CUDA_VERSION}-trt${trt_version_long}-ga-20190506_1-1_amd64.deb"

ENV TENSORRT_x86_64_DEBS="libnvinfer5_${trt_version_short}-1+cuda${CUDA_VERSION}_amd64.deb \
                          libnvinfer-dev_${trt_version_short}-1+cuda${CUDA_VERSION}_amd64.deb \
                          python-libnvinfer_${trt_version_short}-1+cuda${CUDA_VERSION}_amd64.deb \
                          python3-libnvinfer_${trt_version_short}-1+cuda${CUDA_VERSION}_amd64.deb \
                          uff-converter-tf_${trt_version_short}-1+cuda${CUDA_VERSION}_amd64.deb \
                          graphsurgeon-tf_${trt_version_short}-1+cuda${CUDA_VERSION}_amd64.deb"

ENV TRT_AARCH64_LINUX_DEBS="libnvinfer5-cross-aarch64_${trt_version_short}-1+cuda${CUDA_VERSION}_all.deb \
                            libnvinfer-dev-cross-aarch64_${trt_version_short}-1+cuda${CUDA_VERSION}_all.deb"

ENV TRT_AARCH64_QNX_DEBS="libnvinfer5-cross-qnx_${trt_version_short}-1+cuda${CUDA_VERSION}_all.deb \
                      libnvinfer-dev-cross-qnx_${trt_version_short}-1+cuda${CUDA_VERSION}_all.deb"

RUN apt-get update \
    && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
        libtool \
        rsync \
        pkg-config \
        python \
        python-dev \
        python3 \
        python3-dev \
        x264 v4l-utils \
        gcc-aarch64-linux-gnu  \
        g++-aarch64-linux-gnu \ 
        libjpeg-dev \
        curl \
        ca-certificates \
        wget \
        unzip \ 
        git \
        nasm \
        pkg-config \
        dh-autoreconf \
        make\
        g++\
        libboost-all-dev \
        unzip && \
    rm -rf /var/lib/apt/lists/*  

RUN curl -f -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

RUN curl -f -O https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    rm get-pip.py


RUN pip install --upgrade --no-cache-dir numpy

RUN pip install --upgrade --no-cache-dir \
    pillow \
    pip \
    protobuf \
    pycuda \
    setuptools


RUN pip3 install --upgrade --no-cache-dir numpy

RUN pip3 install --upgrade --no-cache-dir \
    pillow \
    pip \
    protobuf \
    pycuda \
    setuptools

COPY pdk_files /pdk_files
###########################################################
# CUDA
###########################################################
#RUN mv /usr/local/cuda-${CUDA_VERSION} /tmp/cuda-backup
RUN mv /pdk_files/${cuda_repo_x86_64} cuda.deb
RUN mv /pdk_files/${cuda_repo_cross_aarch64_linux} cuda-repo-cross-aarch64.deb
RUN mv /pdk_files/${cuda_repo_cross_aarch64_qnx} cuda-repo-cross-qnx.deb

ENV REPO_DEBS="cuda.deb \
               cuda-repo-cross-qnx.deb \
               cuda-repo-cross-aarch64.deb"

RUN dpkg -i $REPO_DEBS

ENV CUDA_PACKAGES="nvrtc nvgraph cusolver cufft curand cusparse npp nvjpeg cudart cupti cupti-dev compiler misc-headers command-line-tools nvrtc-dev nvml-dev nvgraph-dev cusolver-dev cufft-dev curand-dev cusparse-dev npp-dev nvjpeg-dev cudart-dev driver-dev nvcc toolkit libraries-dev tools visual-tools"
RUN echo "for i in \$CUDA_PACKAGES; do echo \"cuda-\$i-\${cuda_version_dash}=\${cuda_version_long}-1\";done" | bash > /tmp/cuda-packages.txt

#Install CUDA 10
RUN apt-get update \
    && apt-get -o Dpkg::Options::="--force-overwrite" --no-install-recommends install -y $(cat /tmp/cuda-packages.txt) --reinstall --allow-downgrades \
    # Random cuda libs in random places...
    && apt-get install --no-install-recommends -y libcublas-dev --reinstall --allow-downgrades \
    && apt-mark hold $(cat /tmp/cuda-packages.txt) \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/cuda-packages.txt

RUN mv /usr/lib/x86_64-linux-gnu/libcublas.so* /usr/local/cuda-${CUDA_VERSION}/targets/x86_64-linux/lib && \
    mv /usr/include/cublas* /usr/local/cuda-${CUDA_VERSION}/include

RUN rm -rf /usr/local/cuda \
    && ln -s /usr/local/cuda-${CUDA_VERSION} /usr/local/cuda

#RUN ls /tmp
#RUN rsync -a --ignore-existing /tmp/cuda-backup/lib64 /usr/local/cuda/lib64

RUN apt-get update \
    && apt-get install --no-install-recommends -y cuda-cross-aarch64 cuda-cross-aarch64-${cuda_version_dash} --reinstall --allow-downgrades \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/cuda-packages.txt

RUN apt-get update \
    && apt-get install --no-install-recommends -y cuda-cross-qnx \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/cuda-packages.txt

RUN cp -r /usr/local/cuda-${CUDA_VERSION}/bin /usr/local/cuda-${CUDA_VERSION}/targets/x86_64-linux \
    && mv /usr/local/cuda-${CUDA_VERSION}/extras /usr/local/cuda-${CUDA_VERSION}/targets/x86_64-linux \
    && ln -s /usr/local/cuda-${CUDA_VERSION}/targets/x86_64-linux/extras /usr/local/cuda-${CUDA_VERSION}/extras
    #&& mkdir -p /usr/local/cuda-${CUDA_VERSION}/targets/aarch64-qnx/extras/CUPTI \
    #&& cp -r /usr/local/cuda-${CUDA_VERSION}/targets/x86_64-linux/extras/CUPTI/include /usr/local/cuda-${CUDA_VERSION}/targets/aarch64-qnx/extras/CUPTI

RUN rm -rf /usr/local/cuda-${CUDA_VERSION}/doc
RUN find / -name "*cublas*"
RUN mv /usr/lib/aarch64-linux-gnu/libcublas* /usr/local/cuda/targets/aarch64-linux/lib \
    && mv /usr/lib/aarch64-qnx-gnu/libcublas* /usr/local/cuda/targets/aarch64-qnx/lib \
    && mv /usr/include/aarch64-linux-gnu/cublas* /usr/local/cuda/targets/aarch64-linux/include \
    && mv /usr/include/aarch64-qnx-gnu/cublas* /usr/local/cuda/targets/aarch64-qnx/include

#RUN cd /pdk_files \
#    && dpkg -i ${CUDNN_x86_64_DEBS}

#TODO: REMOVE THE LIBNVINFER SAMPLES DEPENDENCY
RUN cd /pdk_files \ 
    && dpkg -i ${tensorrt_x86_64_repo} \
    && rm -rf ${tensorrt_x86_64_repo} \
    && apt-get update \
    && apt-get download libcudnn7=${cudnn_version_long}-1+cuda${CUDA_VERSION} libcudnn7-dev=${cudnn_version_long}-1+cuda${CUDA_VERSION} libnvinfer5=${trt_version_short}-1+cuda${CUDA_VERSION} libnvinfer-dev=${trt_version_short}-1+cuda${CUDA_VERSION} uff-converter-tf graphsurgeon-tf python3-libnvinfer=${trt_version_short}-1+cuda${CUDA_VERSION} python-libnvinfer=${trt_version_short}-1+cuda${CUDA_VERSION} \
    && dpkg -i ${CUDNN_x86_64_DEBS} \
    && rm -rf ${CUDNN_x86_64_DEBS} \
    && dpkg -i ${TENSORRT_x86_64_DEBS} \
    && rm -rf ${TENSORRT_x86_64_DEBS}

RUN mkdir -p /usr/local/cuda-${CUDA_VERSION}/dl/targets/x86_64-linux \
    && cd /usr/local/cuda-${CUDA_VERSION}/dl/targets/x86_64-linux \
    && mkdir include lib lib64\
    && mv /usr/lib/x86_64-linux-gnu/libnv* lib \
    && mv /usr/include/x86_64-linux-gnu/Nv* include \
    && mv /usr/lib/x86_64-linux-gnu/libcudnn* lib \
    && mv /usr/include/x86_64-linux-gnu/cudnn* include/cudnn.h \
    && cd lib \
    && rm /etc/alternatives/libcudnn* \
    && ln -s /usr/local/cuda-${CUDA_VERSION}/dl/targets/x86_64-linux/include/cudnn.h /etc/alternatives/libcudnn \
    && ln -s /usr/local/cuda-${CUDA_VERSION}/dl/targets/x86_64-linux/lib/libcudnn.so.7 /etc/alternatives/libcudnn_so \
    && rm -rf /usr/local/cuda-${CUDA_VERSION}/*sight* /usr/local/cuda-${CUDA_VERSION}/samples

###########################################################
# ARM Linux Libs
###########################################################
RUN cd /pdk_files \
    && dpkg -i ${CUDNN_AARCH64_LINUX_DEBS}

RUN cd /pdk_files \
    && dpkg -i ${TRT_AARCH64_LINUX_DEBS}

RUN mkdir -p /usr/local/cuda-${CUDA_VERSION}/dl/targets/aarch64-linux/include /usr/local/cuda-${CUDA_VERSION}/dl/targets/aarch64-linux/lib \
    && mv /usr/lib/aarch64-linux-gnu/* /usr/local/cuda-${CUDA_VERSION}/dl/targets/aarch64-linux/lib \
    && mv /usr/include/aarch64-linux-gnu/* /usr/local/cuda-${CUDA_VERSION}/dl/targets/aarch64-linux/include

###########################################################
# QNX Libs
###########################################################

COPY qnx_toolchain /qnx
RUN rsync -a /qnx/host/linux/x86_64/ /
#RUN mkdir -p /lib64/qnx7/stubs && mv /qnx/lib64/* /lib64/qnx7/stubs
RUN mv /qnx/target/qnx7 /usr/aarch64-unknown-nto-qnx
#RUN rm -rf /usr/aarch64-unknown-nto-qnx/armle-v7 /usr/aarch64-unknown-nto-qnx/x86 /usr/aarch64-unknown-nto-qnx/x86_64
RUN rm -rf /qnx

RUN cd /pdk_files \
    && dpkg -i ${CUDNN_AARCH64_QNX_DEBS}

RUN cd /pdk_files \
    && dpkg -i ${TRT_AARCH64_QNX_DEBS}

RUN mkdir -p /usr/local/cuda-${CUDA_VERSION}/dl/targets/aarch64-qnx/include /usr/local/cuda-${CUDA_VERSION}/dl/targets/aarch64-qnx/lib \
    && mv /usr/lib/aarch64-unknown-nto-qnx/* /usr/local/cuda-${CUDA_VERSION}/dl/targets/aarch64-qnx/lib \
    && mv /usr/include/aarch64-unknown-nto-qnx/* /usr/local/cuda-${CUDA_VERSION}/dl/targets/aarch64-qnx/include

ENV QNX_HOST=/
ENV QNX_TARGET=/usr/aarch64-unknown-nto-qnx

RUN rm -rf *.deb *.patch
RUN rm -rf /pdk_files

ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/local/cuda/lib64:/usr/local/cuda/dl/targets/x86_64-linux/lib:/usr/local/cuda/dl/targets/x86_64-linux/lib64:/usr/lib:/lib:$LD_LIBRARY_PATH
