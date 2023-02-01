# Copyright 2015 gRPC authors.
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

FROM debian:jessie

# Install Git and basic packages.
RUN apt-get update && apt-get install --no-install-recommends -y \
  autoconf \
  autotools-dev \
  build-essential \
  bzip2 \
  ccache \
  curl \
  dnsutils \
  gcc \
  gcc-multilib \
  git \
  golang \
  gyp \
  lcov \
  libc6 \
  libc6-dbg \
  libc6-dev \
  libgtest-dev \
  libtool \
  make \
  perl \
  strace \
  python-dev \
  python-setuptools \
  python-yaml \
  telnet \
  unzip \
  wget \
  zip && apt-get clean && rm -rf /var/lib/apt/lists/*;

#================
# Build profiling
RUN apt-get update && apt-get install --no-install-recommends -y time && apt-get clean && rm -rf /var/lib/apt/lists/*;

# Google Cloud platform API libraries
RUN apt-get update && apt-get install --no-install-recommends -y python-pip && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade google-api-python-client oauth2client

#====================
# Python dependencies

# Install dependencies

RUN apt-get update && apt-get install --no-install-recommends -y \
    python-all-dev \
    python3-all-dev \
    python-pip && rm -rf /var/lib/apt/lists/*;

# Install Python packages from PyPI
RUN pip install --no-cache-dir --upgrade pip==10.0.1
RUN pip install --no-cache-dir virtualenv
RUN pip install --no-cache-dir futures==2.2.0 enum34==1.0.4 protobuf==3.5.2.post1 six==1.10.0 twisted==17.5.0

#=================
# C++ dependencies
RUN apt-get update && apt-get -y --no-install-recommends install libgflags-dev libgtest-dev libc++-dev clang && apt-get clean && rm -rf /var/lib/apt/lists/*;

#=================
# Use cmake 3.6 from jessie-backports
# should only be used for images based on debian jessie.

RUN echo "deb http://ftp.debian.org/debian jessie-backports main" | tee /etc/apt/sources.list.d/jessie-backports.list
RUN apt-get update && apt-get install --no-install-recommends -t jessie-backports -y cmake && apt-get clean && rm -rf /var/lib/apt/lists/*;


RUN mkdir /var/local/jenkins

#================
# libuv
RUN cd /tmp && wget https://dist.libuv.org/dist/v1.9.1/libuv-v1.9.1.tar.gz && tar -xf libuv-v1.9.1.tar.gz && cd libuv-v1.9.1 && sh autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr && make && make install && rm libuv-v1.9.1.tar.gz

# Install gcc-4.8 and other relevant items
RUN apt-get update && apt-get -y --no-install-recommends install gcc-4.8 gcc-4.8-multilib g++-4.8 g++-4.8-multilib && apt-get clean && rm -rf /var/lib/apt/lists/*;

# Define the default command.
CMD ["bash"]
