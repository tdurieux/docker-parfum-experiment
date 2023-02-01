# Copyright (c) 2021, NVIDIA CORPORATION.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

ARG FROM_IMAGE_NAME=gitlab-master.nvidia.com:5005/dl/dgx/pytorch:master-py3-devel

FROM ${FROM_IMAGE_NAME}

ARG SM="80"
ARG ENABLE_MULTINODES=ON

ARG RAPIDS_VERSION=21.06
ARG HWLOC_VERSION=2.4.1
ARG RELEASE=true

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        clang-format \
        libtbb-dev \
        libaio-dev && \
    rm -rf /var/lib/apt/lists/*

ENV PATH=/usr/local/bin:$PATH

# mpi4py
RUN pip3 install --no-cache-dir mpi4py

# Rapids/rmm
ENV CONDA_PREFIX=/opt/conda
RUN mkdir -p /var/tmp && cd /var/tmp && git clone --depth=1 --branch branch-${RAPIDS_VERSION} https://github.com/rapidsai/rmm.git rmm && cd - && \
    cd /var/tmp/rmm && \
    mkdir -p build && cd build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=$CONDA_PREFIX -DBUILD_TESTS=OFF && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    rm -rf /var/tmp/rmm

# CUDA-Aware hwloc
RUN cd /opt/hpcx/ompi/include/openmpi/opal/mca/hwloc/hwloc201 && rm -rfv hwloc201.h hwloc/include/hwloc.h
RUN mkdir -p /var/tmp && wget -q -nc --no-check-certificate -P /var/tmp https://download.open-mpi.org/release/hwloc/v2.4/hwloc-${HWLOC_VERSION}.tar.gz && \
    mkdir -p /var/tmp && tar -x -f /var/tmp/hwloc-${HWLOC_VERSION}.tar.gz -C /var/tmp && \
    cd /var/tmp/hwloc-${HWLOC_VERSION} && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" CPPFLAGS="-I/usr/local/cuda/include/ -L/usr/local/cuda/lib64/" LDFLAGS="-L/usr/local/cuda/lib64" --enable-cuda && \
    make -j$(nproc) && make install && \
    rm -rf /var/tmp/hwloc-${HWLOC_VERSION} /var/tmp/hwloc-${HWLOC_VERSION}.tar.gz

# Env variables for NCCL
ENV NCCL_LAUNCH_MODE=PARALLEL \
    NCCL_COLLNET_ENABLE=0

# ENV variables for Sharp
ENV SHARP_COLL_NUM_COLL_GROUP_RESOURCE_ALLOC_THRESHOLD=0 \
    SHARP_COLL_LOCK_ON_COMM_INIT=1 \
    SHARP_COLL_LOG_LEVEL=3 \
    HCOLL_ENABLE_MCAST=0

RUN ln -s /usr/lib/x86_64-linux-gnu/libibverbs.so.1.14.36.0 /usr/lib/x86_64-linux-gnu/libibverbs.so

WORKDIR /workspace/dlrm
RUN pip3 install --upgrade --no-cache-dir https://github.com/mlcommons/logging/archive/1.0.0-rc2.zip
COPY . .

# HugeCTR
RUN if [ "$RELEASE" = "true" ]; \
    then \
        cd /workspace/dlrm && \
        mkdir build && cd build && \
        cmake -DCMAKE_BUILD_TYPE=Release -DSM=$SM \
            -DENABLE_MULTINODES=$ENABLE_MULTINODES -DSHARP_A2A=OFF -DDISABLE_CUDF=ON .. && \
        make -j$(nproc) && make install && \
        chmod +x /usr/local/hugectr/bin/* && \
        chmod +x /usr/local/hugectr/lib/* && \
        rm -rf /workspace/dlrm/build; \
    else \
      echo "Build container for development successfully"; \
    fi
ENV PATH=/usr/local/hugectr/bin:$PATH \
    LIBRARY_PATH=/usr/local/hugectr/lib:$LIBRARY_PATH \
    LD_LIBRARY_PATH=/usr/local/hugectr/lib:$LD_LIBRARY_PATH \
    PYTHONPATH=/usr/local/hugectr/lib:$PYTHONPATH

RUN rm /usr/lib/x86_64-linux-gnu/libibverbs.so

HEALTHCHECK NONE
ENTRYPOINT []
CMD ["/bin/bash"]
