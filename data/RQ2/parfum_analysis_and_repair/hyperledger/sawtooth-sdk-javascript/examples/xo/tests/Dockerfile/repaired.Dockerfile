# Copyright 2018 Cargill Incorporated
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


FROM ubuntu:xenial

RUN echo "deb http://repo.sawtooth.me/ubuntu/nightly xenial universe" >> /etc/apt/sources.list \
 && (apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 44FC67F19B2466EA \
 || apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 44FC67F19B2466EA) \
 && apt-get update

RUN apt-get install --no-install-recommends -y -q \
    python3-sawtooth-cli \
    python3-sawtooth-integration \
    python3-sawtooth-sdk \
    python3-sawtooth-signing \
    python3-sawtooth-xo-tests && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y -q --allow-downgrades \
    git \
    python3 \
    python3-stdeb && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y -q --allow-downgrades \
    python3-grpcio \
    python3-grpcio-tools \
    python3-protobuf && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y -q --allow-downgrades \
    net-tools \
    python3-cbor \
    python3-colorlog \
    python3-secp256k1 \
    python3-toml \
    python3-yaml \
    python3-zmq && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y -q \
    python3-cov-core \
    python3-nose2 \
    python3-pip && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /var/log/sawtooth

ENV PATH=$PATH:/project/sawtoothsdk-javascript/bin

WORKDIR /project/sawtooth-sdk-javascript
