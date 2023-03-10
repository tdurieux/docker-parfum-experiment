# Copyright 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#  * Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#  * Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#  * Neither the name of NVIDIA CORPORATION nor the names of its
#    contributors may be used to endorse or promote products derived
#    from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ``AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
# OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#
# Multistage build.
#
ARG BASE_IMAGE=tritonserver
ARG BUILD_IMAGE=tritonserver_build
ARG SDK_IMAGE=tritonserver_sdk
ARG TRITON_PATH=/home/ubuntu

FROM ${SDK_IMAGE} AS sdk
FROM $BASE_IMAGE
# Ensure apt-get won't prompt for selecting options
ENV DEBIAN_FRONTEND=noninteractive
# install platform specific packages
RUN if [ $(cat /etc/os-release | grep 'VERSION_ID="20.04"' | wc -l) -ne 0 ]; then \
        apt-get update && \
        apt-get install -y --no-install-recommends \
                libpng-dev; rm -rf /var/lib/apt/lists/*; \
    elif [ $(cat /etc/os-release | grep 'VERSION_ID="18.04"' | wc -l) -ne 0 ]; then \
        apt-get update && \
        apt-get install -y --no-install-recommends \
                libpng-dev; rm -rf /var/lib/apt/lists/*; \
    else \
        echo "Ubuntu version must be either 18.04 or 20.04" && \
        exit 1; \
    fi

RUN apt-get update && apt-get install -y --no-install-recommends \
                              python3-dev \
                              python3-pip \
                              build-essential \
                              wget && \
    rm -rf /var/lib/apt/lists/*

RUN rm -f /usr/bin/python && \
    ln -s /usr/bin/python3 /usr/bin/python

RUN pip3 install --no-cache-dir --upgrade wheel setuptools && \
    pip3 install --no-cache-dir --upgrade numpy pillow attrdict future grpcio requests gsutil awscli six grpcio-channelz

WORKDIR /opt/tritonserver
# Copy the entire qa repo to the /opt/tritonserver/qa repo
COPY --from=tritonserver_build /workspace/qa qa
COPY --chown=1000:1000 --from=sdk /workspace/install client_tmp
RUN mkdir -p qa/clients && mkdir -p qa/pkgs && \
    cp -a client_tmp/bin/* qa/clients/. && \
    cp client_tmp/lib/libgrpcclient.so qa/clients/. && \
    cp client_tmp/lib/libhttpclient.so qa/clients/. && \
    cp client_tmp/python/*.py qa/clients/. && \
    cp client_tmp/python/triton*.whl qa/pkgs/. && \
    cp client_tmp/java/examples/*.jar qa/clients/. && \
    rm -rf client_tmp
# Create mount paths for lib
RUN mkdir /mylib && mkdir /home/ubuntu

ENV TRITON_PATH ${TRITON_PATH}
ENV LD_LIBRARY_PATH /opt/tritonserver/qa/clients:${LD_LIBRARY_PATH}
