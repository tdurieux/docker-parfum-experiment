# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM ubuntu:xenial

# Build Python 3.8.6 from source because pandas doesn't support xenial's
# Python3 version (3.5.2).
ENV PYTHON_VERSION 3.8.6
RUN apt-get update -y && apt-get install --no-install-recommends -y \
    build-essential \
    rsync \
    curl \
    zlib1g-dev \
    libncurses5-dev \
    libgdbm-dev \
    libnss3-dev \
    libssl-dev \
    libreadline-dev \
    libffi-dev \
    virtualenv \
    libbz2-dev \
    liblzma-dev \
    libsqlite3-dev && rm -rf /var/lib/apt/lists/*;

RUN cd /tmp/ && \
    curl -f -O https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz && \
    tar -xvf Python-$PYTHON_VERSION.tar.xz && \
    cd Python-$PYTHON_VERSION && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-loadable-sqlite-extensions --enable-optimizations && \
    make -j install && \
    rm -r /tmp/Python-$PYTHON_VERSION.tar.xz /tmp/Python-$PYTHON_VERSION

# Install common python dependencies.
COPY ./requirements.txt /
RUN pip3 install --no-cache-dir -r /requirements.txt

# Install google-cloud-sdk.
RUN apt-get update -y && apt-get install --no-install-recommends -y \
    apt-transport-https \
    lsb-release && rm -rf /var/lib/apt/lists/*;
RUN CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb https://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" \
    | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg \
    | apt-key add - && \
    apt-get update -y && \
    apt-get install --no-install-recommends -y google-cloud-sdk && rm -rf /var/lib/apt/lists/*;
