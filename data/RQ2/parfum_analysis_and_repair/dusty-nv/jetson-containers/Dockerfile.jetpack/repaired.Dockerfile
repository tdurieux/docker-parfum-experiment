# Copyright (c) 2022, NVIDIA CORPORATION. All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.
#
# Builds the self-contained JetPack Docker container, including development 
# headers/libraries/samples for CUDA Toolkit, cuDNN, TensorRT, VPI, and OpenCV.
#
# To run the automated build script that uses this Dockerfile:
#
#   $ cd jetson-containers
#   $ scripts/docker_build_jetpack.sh
#

ARG BASE_IMAGE=nvcr.io/nvidia/l4t-base:r34.1
FROM ${BASE_IMAGE}


#
# setup environment
#
ENV DEBIAN_FRONTEND=noninteractive
ENV CUDA_HOME="/usr/local/cuda"
ENV PATH="/usr/local/cuda/bin:${PATH}"
ENV LD_LIBRARY_PATH="/usr/local/cuda/lib64:${LD_LIBRARY_PATH}"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
            ca-certificates \
		  gnupg2 \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean


#
# configure nvidia apt repo
#
COPY packages/nvidia-l4t-apt-source.list /tmp/apt/nvidia-l4t-apt-source.list
COPY packages/nvidia-l4t-apt-source.clean.list /tmp/apt/nvidia-l4t-apt-source.clean.list

RUN apt-key adv --fetch-key https://repo.download.nvidia.com/jetson/jetson-ota-public.asc && \
    cp /etc/apt/sources.list /tmp/apt && \
    cat /tmp/apt/nvidia-l4t-apt-source.list >> /etc/apt/sources.list && \
    cat /etc/apt/sources.list
    
    
#
# install CUDA Toolkit
#    
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
		  cuda-toolkit-* \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean


#
# install cuDNN
#    
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
		  libcudnn*-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean
    
    
#
# install TensorRT
#    
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
		  tensorrt \
		  python3-libnvinfer-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean
    

#
# install VPI
#    
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
		  vpi2-dev \
		  vpi2-samples \
		  python3.8-vpi2 \
		  python3-pip \
		  python3-pil \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean
    
RUN pip3 install --no-cache-dir --verbose numpy
    

#
# install OpenCV (with CUDA)
#
ARG OPENCV_URL=https://nvidia.box.com/shared/static/2hssa5g3v28ozvo3tc3qwxmn78yerca9.gz
ARG OPENCV_DEB=OpenCV-4.5.0-aarch64.tar.gz

RUN apt-get purge -y '*opencv*' || echo "previous OpenCV installation not found" && \
    mkdir opencv && \
    cd opencv && \
    wget --quiet --show-progress --progress=bar:force:noscroll --no-check-certificate ${OPENCV_URL} -O ${OPENCV_DEB} && \
    tar -xzvf ${OPENCV_DEB} && \
    dpkg -i --force-depends *.deb && \
    apt-get update && \
    apt-get install -y -f --no-install-recommends && \
    dpkg -i *.deb && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    cd ../ && \
    rm -rf opencv && \
    PYTHON3_VERSION=`python3 -c 'import sys; version=sys.version_info[:3]; print("{0}.{1}".format(*version))'` && \
    cp -r /usr/include/opencv4 /usr/local/include/opencv4 && \
    cp -r /usr/lib/python${PYTHON3_VERSION}/dist-packages/cv2 /usr/local/lib/python${PYTHON3_VERSION}/dist-packages/cv2

 
#
# clean-up apt repos
#