# Copyright 2017 Intel Corporation
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
# ------------------------------------------------------------------------------

# Description:
#   Builds an image to be used when developing in JavaScript. The default CMD is to run
#   build_javascript.
#
# Build:
#   $ cd sawtooth-sdk-javascript/
#   $ docker build . -f js-sdk-processors -t js-sdk-processors
#
# Run:
#   $ cd sawtooth-sdk-javascript
#   $ docker run -v $(pwd):/project/sawtooth-sdk-javascript js-sdk-processors

FROM ubuntu:xenial

LABEL "install-type"="mounted"

RUN apt-get update && apt-get install -y -q --no-install-recommends \
    curl \
    ca-certificates \
    pkg-config \
    build-essential \
    libfontconfig \
    libzmq3-dev \
 && curl -s -S -o /tmp/setup-node.sh https://deb.nodesource.com/setup_6.x \
 && chmod 755 /tmp/setup-node.sh \
 && /tmp/setup-node.sh \
 && apt-get install nodejs -y -q \
 && rm /tmp/setup-node.sh \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN \
 if [ ! -z $HTTP_PROXY ] && [ -z $http_proxy ]; then \
  http_proxy=$HTTP_PROXY; \
 fi; \
 if [ ! -z $HTTPS_PROXY ] && [ -z $https_proxy ]; then \
  https_proxy=$HTTPS_PROXY; \
 fi; \
 if [ ! -z $http_proxy ]; then \
  npm config set proxy $http_proxy; \
 fi; \
 if [ ! -z $https_proxy ]; then \
  npm config set https-proxy $https_proxy; \
 fi

RUN npm install -g \
    prebuild-install \
    phantomjs-prebuilt

EXPOSE 4004/tcp

RUN mkdir -p /project/sawtooth-sdk-javascript/ \
 && mkdir -p /var/log/sawtooth \
 && mkdir -p /var/lib/sawtooth \
 && mkdir -p /etc/sawtooth \
 && mkdir -p /etc/sawtooth/keys

ENV PATH=$PATH:/project/sawtooth-sdk-javascript/bin:/node_modules/phantomjs-prebuilt/bin

WORKDIR /

CMD /project/sawtooth-sdk-javascript/bin/build_sdk \
 && /project/sawtooth-sdk-javascript/bin/build_intkey \
 && /project/sawtooth-sdk-javascript/bin/build_xo
