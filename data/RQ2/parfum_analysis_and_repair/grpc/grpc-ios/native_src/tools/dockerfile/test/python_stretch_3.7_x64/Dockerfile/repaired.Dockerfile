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



RUN apt-get update && apt-get -t buster --no-install-recommends install -y python3.7 python3-all-dev && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://bootstrap.pypa.io/get-pip.py | python3.7

# for Python test coverage reporting
RUN python3.7 -m pip install coverage

# Google Cloud Platform API libraries
# These are needed for uploading test results to BigQuery (e.g. by tools/run_tests scripts)
RUN python3 -m pip install --upgrade google-auth==1.23.0 google-api-python-client==1.12.8 oauth2client==4.1.0

