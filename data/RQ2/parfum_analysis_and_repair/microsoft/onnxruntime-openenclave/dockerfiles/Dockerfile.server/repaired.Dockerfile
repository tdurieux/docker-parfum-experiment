#-------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
#--------------------------------------------------------------------------
# Official docker container for ONNX Runtime Server
# Ubuntu 16.04, CPU version, Python 3.
#--------------------------------------------------------------------------

FROM ubuntu:16.04 AS minimal
MAINTAINER Harry Yang "huayang@microsoft.com"

FROM ubuntu:16.04 AS build
ARG PYTHON_VERSION=3.5
ARG ONNXRUNTIME_REPO=https://github.com/Microsoft/onnxruntime
ARG ONNXRUNTIME_SERVER_BRANCH=master
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -y sudo git bash && rm -rf /var/lib/apt/lists/*;

ENV PATH="/opt/cmake/bin:${PATH}"
RUN git clone --single-branch --branch ${ONNXRUNTIME_SERVER_BRANCH} --recursive ${ONNXRUNTIME_REPO} onnxruntime
RUN /onnxruntime/tools/ci_build/github/linux/docker/scripts/install_ubuntu.sh -p ${PYTHON_VERSION} \
    && /onnxruntime/tools/ci_build/github/linux/docker/scripts/install_server_deps.sh

ENV PATH="/usr/local/go/bin:${PATH}"

WORKDIR /
RUN mkdir -p /onnxruntime/build && cd /onnxruntime/build && cmake -DCMAKE_BUILD_TYPE=Release /onnxruntime/server \
    && make -j$(getconf _NPROCESSORS_ONLN)

FROM minimal AS final
COPY --from=build /onnxruntime/build/onnxruntime_server /onnxruntime/server/
COPY --from=build /usr/lib/libonnxruntime.so.1.2.0 /usr/local/lib/libcares.so.2.3.0 /usr/lib/
RUN ln -s /usr/lib/libonnxruntime.so.1.2.0 /usr/lib/libonnxruntime.so && ln -s /usr/local/lib/libcares.so.2.3.0 /usr/local/lib/libcares.so.2 && ln -s /usr/local/lib/libcares.so.2 /usr/local/lib/libcares.so && ldconfig /usr/local/lib && apt-get update \
    && apt-get install --no-install-recommends -y libgomp1 libre2-1v5 libssl1.0.0 && rm -rf /var/lib/apt/lists/*;
WORKDIR /onnxruntime/server/
ENTRYPOINT ["/onnxruntime/server/onnxruntime_server"]
