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

# docker build -f rest_api/Dockerfile -t sawtooth-rest-api-local .

# -------------=== rest_api build ===-------------

FROM ubuntu:bionic

RUN apt-get update \
 && apt-get install --no-install-recommends gnupg -y && rm -rf /var/lib/apt/lists/*;

RUN echo "deb http://repo.sawtooth.me/ubuntu/nightly bionic universe" >> /etc/apt/sources.list \
 && (apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 44FC67F19B2466EA \
 || apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 44FC67F19B2466EA) \
 && apt-get update

RUN apt-get install --no-install-recommends -y -q \
    git \
    python3 \
    python3-stdeb && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y -q \
    python3-grpcio \
    python3-grpcio-tools \
    python3-protobuf && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y -q \
    python3-sawtooth-sdk && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y -q \
    python3-aiodns \
    python3-aiohttp \
    python3-colorlog \
    python3-cchardet \
    python3-pyformance \
    python3-toml \
    python3-yaml \
    python3-zmq && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /var/log/sawtooth

ENV PATH=$PATH:/project/sawtooth-core/bin

WORKDIR /project/sawtooth-core

CMD echo "\033[0;32m--- Building rest_api ---\n\033[0m" \
 && bin/protogen \
 && cd rest_api \
 && python3 setup.py clean --all \
 && python3 setup.py build
