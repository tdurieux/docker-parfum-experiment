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

# docker build -f contracts/sawtooth-pike/cli/Dockerfile-installed-bionic -t sawtooth-pike-cli .

# -------------=== pike cli build ===-------------

FROM ubuntu:bionic as pike-cli-builder

ENV VERSION=AUTO_STRICT

RUN apt-get update \
 && apt-get install -y \
 curl \
 gcc \
 git \
 libssl-dev \
 libzmq3-dev \
 pkg-config \
 python3 \
 unzip

# For Building Protobufs
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y \
 && curl -OLsS https://github.com/google/protobuf/releases/download/v3.5.1/protoc-3.5.1-linux-x86_64.zip \
 && unzip protoc-3.5.1-linux-x86_64.zip -d protoc3 \
 && rm protoc-3.5.1-linux-x86_64.zip

ENV PATH=$PATH:/protoc3/bin
RUN /root/.cargo/bin/cargo install cargo-deb

COPY . /project

WORKDIR /project/contracts/sawtooth-pike/cli

RUN sed -i -e s/version.*$/version\ =\ \"$(../../../bin/get_version)\"/ Cargo.toml
RUN /root/.cargo/bin/cargo deb

# -------------=== pike cli docker build ===-------------

FROM ubuntu:bionic

COPY --from=pike-cli-builder /project/contracts/sawtooth-pike/cli/target/debian/pike-cli*.deb /tmp

RUN apt-get update \
 && apt-get install gnupg -y

RUN echo "deb [arch=amd64] http://repo.sawtooth.me/ubuntu/nightly bionic universe" >> /etc/apt/sources.list \
 && apt-get update \
 && (apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 44FC67F19B2466EA \
 || apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 44FC67F19B2466EA) \
 && apt-get -f -y install \
    python3-sawtooth-cli \
    python3-sawtooth-sdk \
 && dpkg -i /tmp/pike-cli*.deb || true \
 && apt-get -f -y install

ENTRYPOINT ["tail", "-f", "/dev/null"]
