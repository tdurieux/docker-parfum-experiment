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

# debian 11 = "bullseye"
FROM php:7.3-zts-bullseye

RUN apt-get update && apt-get install --no-install-recommends -y \
  autoconf automake build-essential git libtool curl \
  zlib1g-dev \
  && apt-get clean && rm -rf /var/lib/apt/lists/*;

# install php pthreads from source
# TODO(jtattermusch): is this really needed?
# See https://github.com/grpc/grpc/pull/23056
WORKDIR /tmp
RUN git clone https://github.com/krakjoe/pthreads
RUN cd pthreads && \
  phpize && \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
  make && \
  make install

#====================
# run_tests.py python dependencies

# Basic python dependencies to be able to run tools/run_tests python scripts
# These dependencies are not sufficient to build gRPC Python, gRPC Python
# deps are defined elsewhere (e.g. python_deps.include)
RUN apt-get update && apt-get install --no-install-recommends -y \
  python3 \
  python3-pip \
  python3-setuptools \
  python3-yaml \
  && apt-get clean && rm -rf /var/lib/apt/lists/*;

# use pinned version of pip to avoid sudden breakages
RUN python3 -m pip install --upgrade pip==19.3.1

# TODO(jtattermusch): currently six is needed for tools/run_tests scripts
# but since our python2 usage is deprecated, we should get rid of it.
RUN python3 -m pip install six==1.16.0

# Google Cloud Platform API libraries
# These are needed for uploading test results to BigQuery (e.g. by tools/run_tests scripts)
RUN python3 -m pip install --upgrade google-auth==1.23.0 google-api-python-client==1.12.8 oauth2client==4.1.0


# Install composer
RUN curl -f -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

#=================
# Install cmake
# Note that this step should be only used for distributions that have new enough cmake to satisfy gRPC's cmake version requirement.

RUN apt-get update && apt-get install --no-install-recommends -y cmake && apt-get clean && rm -rf /var/lib/apt/lists/*;

#=================
# Install ccache

# Install ccache from source since ccache 3.x packaged with most linux distributions
# does not support Redis backend for caching.
RUN curl -f -sSL -o ccache.tar.gz https://github.com/ccache/ccache/releases/download/v4.5.1/ccache-4.5.1.tar.gz \
    && tar -zxf ccache.tar.gz \
    && cd ccache-4.5.1 \
    && mkdir build && cd build \
    && cmake -DCMAKE_BUILD_TYPE=Release -DZSTD_FROM_INTERNET=ON -DHIREDIS_FROM_INTERNET=ON .. \
    && make -j4 && make install \
    && cd ../.. \
    && rm -rf ccache-4.5.1 ccache.tar.gz


RUN mkdir /var/local/jenkins


# Seems required by XDS interop tests.
RUN python3 -m pip install virtualenv==16.7.9

# Define the default command.
CMD ["bash"]
