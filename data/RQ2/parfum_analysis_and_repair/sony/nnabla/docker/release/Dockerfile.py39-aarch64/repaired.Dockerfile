# Copyright 2022 Sony Group Corporation.
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

FROM multiarch/debian-debootstrap:arm64-bullseye

ARG PIP_INS_OPTS
ARG PYTHONWARNINGS
ARG CURL_OPTS
ARG WGET_OPTS

ENV DEBIAN_FRONTEND noninteractive

ENV LC_ALL C
ENV LANG C
ENV LANGUAGE C

RUN apt-get update && apt-get install -y --no-install-recommends \
    bzip2 \
    ca-certificates \
    libarchive-dev \
    libatlas-base-dev \
    libhdf5-dev \
    libopenblas-dev \
    liblapack-dev \
    pkg-config \
    python3 \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install ${PIP_INS_OPTS} --upgrade pip
RUN echo "[global]" >/etc/pip.conf
RUN echo "extra-index-url=https://www.piwheels.org/simple" >> /etc/pip.conf
RUN python3 -m pip install ${PIP_INS_OPTS} --no-cache-dir numpy\<1.22
RUN python3 -m pip install ${PIP_INS_OPTS} --no-cache-dir scipy
RUN python3 -m pip install ${PIP_INS_OPTS} --no-cache-dir \
    boto3 \
    cython \
    h5py \
    pillow \
    protobuf \
    pyyaml \
    tqdm

RUN python3 -m pip install ${PIP_INS_OPTS} ipython

ARG NNABLA_VER
RUN pip install --no-cache-dir ${PIP_INS_OPTS} nnabla==${NNABLA_VER}

# Entrypoint
COPY .entrypoint.sh /opt/.entrypoint.sh
RUN chmod +x /opt/.entrypoint.sh

ENTRYPOINT ["/bin/bash", "-c", "/opt/.entrypoint.sh \"${@}\"", "--"]
