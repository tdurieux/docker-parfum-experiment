# Copyright (c) 2019, NVIDIA CORPORATION. All rights reserved.
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

# Default setting is building on ubuntu:16.04
ARG UBUNTU_VERSION=16.04

FROM ubuntu:${UBUNTU_VERSION}

# Ensure apt-get won't prompt for selecting options
ENV DEBIAN_FRONTEND=noninteractive

# install platform specific packages
RUN if [ $(cat /etc/os-release | grep 'VERSION_ID="16.04"' | wc -l) -ne 0 ]; then \
        apt-get update && \
        apt-get install -y --no-install-recommends \
                libcurl3-dev; rm -rf /var/lib/apt/lists/*; \
    elif [ $(cat /etc/os-release | grep 'VERSION_ID="18.04"' | wc -l) -ne 0 ]; then \
        apt-get update && \
        apt-get install -y --no-install-recommends \
                libcurl4-openssl-dev; rm -rf /var/lib/apt/lists/*; \
    else \
        echo "Ubuntu version must be either 16.04 or 18.04" && \
        exit 1; \
    fi

RUN apt-get install -y --no-install-recommends \
            software-properties-common \
            autoconf \
            automake \
            build-essential \
            curl \
            git \
            libopencv-dev \
            libopencv-core-dev \
            libtool \
            pkg-config \
            python \
            python-dev && rm -rf /var/lib/apt/lists/*;

RUN curl -f -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

RUN pip install --no-cache-dir --upgrade setuptools grpcio-tools

# Build the client library and examples
WORKDIR /workspace
COPY Makefile.client .
COPY VERSION .
COPY src src
RUN make -j8 -f Makefile.client all

# Collect the client artifacts into a tar
RUN mkdir -p /tmp/client/bin && \
    cp build/image_client /tmp/client/bin/. && \
    cp build/ensemble_image_client /tmp/client/bin/. && \
    cp build/perf_client /tmp/client/bin/. && \
    cp build/simple_client /tmp/client/bin/. && \
    cp build/simple_string_client /tmp/client/bin/. && \
    cp build/simple_sequence_client /tmp/client/bin/. && \
    mkdir -p /tmp/client/lib && \
    cp build/librequest.so /tmp/client/lib/. && \
    cp build/librequest.a /tmp/client/lib/. && \
    mkdir -p /tmp/client/include && \
    cp build/src/core/api.pb.h /tmp/client/include/. && \
    cp build/src/core/model_config.pb.h /tmp/client/include/. && \
    cp build/src/core/request_status.pb.h /tmp/client/include/. && \
    cp build/src/core/server_status.pb.h /tmp/client/include/. && \
    cp src/clients/c++/request.h /tmp/client/include/. && \
    cp src/clients/c++/request_http.h /tmp/client/include/. && \
    cp src/clients/c++/request_grpc.h /tmp/client/include/. && \
    mkdir -p /tmp/client/python && \
    cp src/clients/python/image_client.py /tmp/client/python/. && \
    cp src/clients/python/ensemble_image_client.py /tmp/client/python/. && \
    cp src/clients/python/grpc_image_client.py /tmp/client/python/. && \
    cp src/clients/python/simple_client.py /tmp/client/python/. && \
    cp src/clients/python/simple_string_client.py /tmp/client/python/. && \
    cp src/clients/python/simple_sequence_client.py /tmp/client/python/. && \
    cp build/dist/dist/*.whl /tmp/client/python/. && \
    export VERSION=`cat /workspace/VERSION` && \
    (cd /tmp/client && tar zcf /workspace/v$VERSION.clients.tar.gz *)

# Install an image needed by the quickstart and other documentation.
COPY qa/images/mug.jpg images/mug.jpg

# Install the dependencies needed to run the client examples. These
# are not needed for building but including them allows this image to
# be used to run the client examples.
RUN pip install --no-cache-dir --upgrade build/dist/dist/tensorrtserver-*.whl numpy pillow
