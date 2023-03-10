# Copyright 2018 The gRPC Authors
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

FROM debian:stretch

#=================
# Basic C core dependencies

# C/C++ dependencies according to https://github.com/grpc/grpc/blob/master/BUILDING.md
RUN apt-get update && apt-get install --no-install-recommends -y \
  build-essential \
  autoconf \
  libtool \
  pkg-config \
  && apt-get clean && rm -rf /var/lib/apt/lists/*;

# GCC
RUN apt-get update && apt-get install --no-install-recommends -y \
  gcc \
  gcc-multilib \
  g++ \
  g++-multilib \
  && apt-get clean && rm -rf /var/lib/apt/lists/*;

# libc6
RUN apt-get update && apt-get install --no-install-recommends -y \
  libc6 \
  libc6-dbg \
  libc6-dev \
  && apt-get clean && rm -rf /var/lib/apt/lists/*;

# Tools
RUN apt-get update && apt-get install --no-install-recommends -y \
  bzip2 \
  curl \
  dnsutils \
  git \
  lcov \
  make \
  strace \
  time \
  unzip \
  wget \
  zip \
  && apt-get clean && rm -rf /var/lib/apt/lists/*;

# Add Debian 'buster' repository, we will need it for installing newer versions of python
RUN echo 'deb http://ftp.de.debian.org/debian buster main' >> /etc/apt/sources.list
RUN echo 'APT::Default-Release "stretch";' | tee -a /etc/apt/apt.conf.d/00local

RUN mkdir /var/local/jenkins


#=================
# Compile CPython 3.6.9 from source

RUN apt-get update && apt-get install --no-install-recommends -y zlib1g-dev libssl-dev && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y jq build-essential libffi-dev && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN cd /tmp && \
    wget -q https://www.python.org/ftp/python/3.6.9/Python-3.6.9.tgz && \
    tar xzvf Python-3.6.9.tgz && \
    cd Python-3.6.9 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make install && rm Python-3.6.9.tgz

RUN cd /tmp && \
    echo "ff7cdaef4846c89c1ec0d7b709bbd54d Python-3.6.9.tgz" > checksum.md5 && \
    md5sum -c checksum.md5

RUN python3.6 -m ensurepip && \
    python3.6 -m pip install coverage


RUN ln -s $(which python3.6) /usr/bin/python3

# Google Cloud Platform API libraries
# These are needed for uploading test results to BigQuery (e.g. by tools/run_tests scripts)
RUN python3 -m pip install --upgrade google-auth==1.23.0 google-api-python-client==1.12.8 oauth2client==4.1.0

