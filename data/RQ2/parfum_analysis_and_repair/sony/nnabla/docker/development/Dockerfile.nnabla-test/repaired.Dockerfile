# Copyright 2021 Sony Corporation.
# Copyright 2021 Sony Group Corporation.
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

# for nnabla>=1.5.0

FROM ubuntu:18.04

ARG PIP_INS_OPTS
ARG PYTHONWARNINGS
ARG CURL_OPTS
ARG WGET_OPTS
ARG APT_OPTS

ENV LC_ALL C
ENV LANG C
ENV LANGUAGE C

ARG PYTHON_VERSION_MAJOR
ARG PYTHON_VERSION_MINOR
ENV PYVERNAME=${PYTHON_VERSION_MAJOR}.${PYTHON_VERSION_MINOR}

ENV DEBIAN_FRONTEND noninteractive

RUN eval ${APT_OPTS} && apt-get update
RUN apt install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN apt-get update

RUN apt-get install -y --no-install-recommends \
       bzip2 \
       ca-certificates \
       ccache \
       clang-format-5.0 \
       cmake \
       curl \
       g++ \
       git \
       libarchive-dev \
       libgoogle-glog-dev \
       libgtest-dev \
       libhdf5-dev \
       libleveldb-dev \
       liblmdb-dev \
       libsnappy-dev \
       libssl-dev \
       libsndfile1 \
       liblzma-dev \
       make \
       openssl \
       unzip \
       wget \
       zip \
       python${PYVERNAME}-dev \
       python3-venv \
       python${PYVERNAME} \
       python${PYVERNAME}-venv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       python${PYVERNAME}-distutils || echo "skip install python-distutils" \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN if [ "${PYVERNAME}" = "3.6" ]; then \
 curl -f ${CURL_OPTS} https://bootstrap.pypa.io/pip/${PYVERNAME}/get-pip.py -o get-pip.py; else \
    curl -f ${CURL_OPTS} https://bootstrap.pypa.io/get-pip.py -o get-pip.py; fi \
    && python${PYVERNAME} get-pip.py ${PIP_INS_OPTS} \
    && rm get-pip.py

RUN update-alternatives --install /usr/bin/python python /usr/bin/python${PYVERNAME} 0

################################################## protobuf
RUN mkdir /tmp/deps \
    && cd /tmp/deps \
    && PROTOVER=3.19.4 \
    && curl -f ${CURL_OPTS} -L https://github.com/google/protobuf/archive/v${PROTOVER}.tar.gz -o protobuf-v${PROTOVER}.tar.gz \
    && tar xvf protobuf-v${PROTOVER}.tar.gz \
    && cd protobuf-${PROTOVER} \
    && mkdir build \
    && cd build \
    && cmake \
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
        -Dprotobuf_BUILD_TESTS=OFF \
        -DCMAKE_CXX_STANDARD=14 \
        -D CMAKE_C_COMPILER=gcc CMAKE_CXX_COMPILER=g++ /usr/bin/gcc \
        ../cmake \
    && make -j8 \
    && make install \
    && cd / \
    && rm -rf /tmp/* && rm protobuf-v${PROTOVER}.tar.gz

################################################## requirements

ADD python/setup_requirements.txt /tmp/deps/
ADD python/requirements.txt /tmp/deps/
ADD python/test_requirements.txt /tmp/deps/

RUN pip install --no-cache-dir ${PIP_INS_OPTS} numpy \
    && pip install --no-cache-dir ${PIP_INS_OPTS} -U -r /tmp/deps/setup_requirements.txt \
    && pip install --no-cache-dir ${PIP_INS_OPTS} -U -r /tmp/deps/requirements.txt \
    && pip install --no-cache-dir ${PIP_INS_OPTS} -U -r /tmp/deps/test_requirements.txt \
    && rm -rf /tmp/*

ENV PATH /tmp/.local/bin:$PATH
ENV LD_LIBRARY_PATH /usr/local/lib64:$LD_LIBRARY_PATH
