# Copyright 2018,2019,2020,2021 Sony Corporation.
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

RUN eval ${APT_OPTS} \
    && apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    clang-format-3.9 \
    cmake \
    curl \
    g++ \
    git \
    make \
    python3.7-dev \
    python3.7 \
    python3-setuptools \
    unzip \
    zip \
    zlib1g-dev \
    libhdf5-dev \
    libarchive-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl -f ${CURL_OPTS} https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
    && python3.7 get-pip.py ${PIP_INS_OPTS} \
    && rm get-pip.py

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.7 0
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 0

ADD python/setup_requirements.txt /tmp/deps/
RUN pip3 install --no-cache-dir ${PIP_INS_OPTS} -U -r /tmp/deps/setup_requirements.txt
ADD python/requirements.txt /tmp/deps/
RUN pip3 install --no-cache-dir ${PIP_INS_OPTS} -U -r /tmp/deps/requirements.txt
ADD doc/requirements.txt /tmp/deps/
RUN sed -i '/nnabla==/d' /tmp/deps/requirements.txt \
    && pip3 install --no-cache-dir ${PIP_INS_OPTS} -U -r /tmp/deps/requirements.txt

RUN apt-get -yqq update \
    && apt-get -yqq install --no-install-recommends \
        build-essential \
        dh-autoreconf \
        pkg-config \
    && git clone https://github.com/google/protobuf.git /protobuf \
    && cd /protobuf \
    && git checkout v3.10.1 \
    && ./autogen.sh \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make \
    && make install \
    && ldconfig \
    # Cleanup
    && apt-get -yqq purge dh-autoreconf \
    && apt-get -yqq clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /protobuf /protoc-gen-doc

RUN apt-get -yqq update \
    && apt-get -yqq install --no-install-recommends \
        doxygen \
        libclang-dev \
        fonts-freefont-ttf \
        graphviz \
        pandoc \
        plantuml \
    && apt-get -yqq clean \
    && rm -rf /var/lib/apt/lists/*
