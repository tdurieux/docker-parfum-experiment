# Copyright 2019 Cargill Incorporated
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

RUN echo "deb [arch=amd64] http://repo.sawtooth.me/ubuntu/bumper/nightly xenial universe" >> /etc/apt/sources.list \
 && (apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 44FC67F19B2466EA \
 || apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 44FC67F19B2466EA) \
 && apt-get update \
 && apt-get install --no-install-recommends -y -q \
    apt-transport-https \
    curl \
    python3-cbor \
    python3-cryptography >=1.7.1 \
    python3-grpcio \
    python3-grpcio-tools \
    python3-lmdb \
    python3-nose2 \
    python3-pip \
    python3-protobuf \
    python3-requests \
    python3-sawtooth-block-info \
    python3-sawtooth-cli \
    python3-sawtooth-intkey \
    python3-sawtooth-rest-api \
    python3-sawtooth-sdk \
    python3-sawtooth-settings \
    python3-sawtooth-validator \
    python3-toml \
    python3-yaml \
    sawtooth-intkey-tp-go \
    sawtooth-intkey-workload \
    sawtooth-smallbank-tp-go \
    sawtooth-smallbank-workload \
    software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir coverage==5.5 --upgrade

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
 && add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) \
         stable"

RUN apt-get update && apt-get install --no-install-recommends -y -q \
    docker-ce && rm -rf /var/lib/apt/lists/*;

ENV PATH=$PATH:/project/sawtooth-poet/bin

WORKDIR /project/sawtooth-poet
