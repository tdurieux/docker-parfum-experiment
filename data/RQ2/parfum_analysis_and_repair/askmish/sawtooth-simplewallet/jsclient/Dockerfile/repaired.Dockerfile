# Copyright 2018 Intel Corporation
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
# -----------------------------------------------------------------------------

FROM ubuntu:bionic

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install --no-install-recommends gnupg -y && rm -rf /var/lib/apt/lists/*;

RUN echo "deb [arch=amd64] http://repo.sawtooth.me/ubuntu/ci bionic universe" >> /etc/apt/sources.list \
 && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 8AA7AF1F1091A5FD \
 && echo "deb [arch=amd64] http://repo.sawtooth.me/ubuntu/chime/stable bionic universe" >> /etc/apt/sources.list \
 && apt-get install -y -q --no-install-recommends \
    apt-utils \
 && apt-get install --no-install-recommends -y -q \
    ca-certificates \
    build-essential \
    python3-sawtooth-cli \
    curl \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

WORKDIR /project/simplewallet/jsclient

ENV PATH "$PATH:/project/simplewallet/jsclient"

EXPOSE 3000

CMD npm install && npm start
