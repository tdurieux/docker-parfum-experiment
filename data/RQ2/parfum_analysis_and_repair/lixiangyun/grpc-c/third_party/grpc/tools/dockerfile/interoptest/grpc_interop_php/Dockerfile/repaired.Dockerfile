# Copyright 2016 gRPC authors.
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

#=================
# PHP dependencies

# Install dependencies

RUN apt-get update && apt-get install --no-install-recommends -y \
    git php5 php5-dev phpunit unzip && rm -rf /var/lib/apt/lists/*;


RUN mkdir /var/local/jenkins

# Install composer
RUN curl -f -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Define the default command.
CMD ["bash"]

