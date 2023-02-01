# Copyright (c) Microsoft Corporation
# All rights reserved.
#
# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
# to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
# BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


FROM pai.build.base:hadoop2.7.2-cuda8.0-cudnn6-devel-ubuntu16.04

ENV TENSORFLOW_VERSION=1.4.0

# For how to run TensorFlow on Hadoop,
# please refer to https://www.tensorflow.org/deploy/hadoop
RUN pip install tensorflow-gpu==${TENSORFLOW_VERSION} && \
    pip3 install tensorflow-gpu==${TENSORFLOW_VERSION}

# Add symbol link for libcuda.so
RUN ln -s /usr/local/cuda/targets/x86_64-linux/lib/stubs/libcuda.so \
          /usr/local/cuda/targets/x86_64-linux/lib/stubs/libcuda.so.1

#update and upgrade, install git
RUN apt-get update && apt-get upgrade -y && apt-get -y install git

ENV LC_ALL C

#if you want to build the docker image with data, please prepare the data first and remove the '#' in next line
#ADD ./data /tmp/data

WORKDIR /root
