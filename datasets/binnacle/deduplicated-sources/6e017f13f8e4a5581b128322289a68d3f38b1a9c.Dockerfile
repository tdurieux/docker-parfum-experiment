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

# docker build -f tp/Dockerfile-installed-xenial -t sawtooth-sabre-tp .

# -------------=== sabre tp build ===-------------

FROM ubuntu:xenial as sabre-tp-builder

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

ENV PATH=$PATH:/protoc3/bin  \
    CARGO_INCREMENTAL=0
RUN /root/.cargo/bin/cargo install cargo-deb

COPY . /project

WORKDIR /project/tp

RUN sed -i -e s/version.*$/version\ =\ \"$(../bin/get_version)\"/ Cargo.toml
RUN /root/.cargo/bin/cargo deb

# -------------=== sabre tp build ===-------------

FROM ubuntu:xenial

COPY --from=sabre-tp-builder /project/tp/target/debian/sawtooth-sabre_*.deb /tmp

RUN apt-get update \
 && dpkg -i /tmp/sawtooth-sabre_*.deb || true \
 && apt-get -f -y install
