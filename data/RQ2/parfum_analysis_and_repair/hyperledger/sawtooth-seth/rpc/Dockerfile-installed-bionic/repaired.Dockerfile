# Copyright 2018 Intel Corporation
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
# ------------------------------------------------------------------------------

# -------------=== seth rpc build ===-------------

FROM ubuntu:bionic

ENV VERSION=AUTO_STRICT

RUN apt-get update \
 && apt-get install --no-install-recommends gnupg -y && rm -rf /var/lib/apt/lists/*;

RUN (apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 44FC67F19B2466EA \
 || apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 44FC67F19B2466EA) \
 && echo 'deb http://repo.sawtooth.me/ubuntu/nightly bionic universe' >> /etc/apt/sources.list \
 && apt-get update \
 && apt-get install --no-install-recommends -y -q \
    curl \
    gcc \
    git \
    libssl-dev \
    libzmq3-dev \
    openssl \
    pkg-config \
    python3 \
    python3-grpcio-tools \
    unzip \
 && curl -f -s -S -o /tmp/setup-node.sh https://deb.nodesource.com/setup_6.x \
 && chmod 755 /tmp/setup-node.sh \
 && /tmp/setup-node.sh \
 && apt-get install --no-install-recommends nodejs -y -q \
 && rm /tmp/setup-node.sh \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN curl -f -OLsS https://github.com/google/protobuf/releases/download/v3.5.1/protoc-3.5.1-linux-x86_64.zip \
 && unzip protoc-3.5.1-linux-x86_64.zip -d protoc3 \
 && rm protoc-3.5.1-linux-x86_64.zip

RUN curl https://sh.rustup.rs -sSf > /usr/bin/rustup-init \
 && chmod +x /usr/bin/rustup-init \
 && rustup-init -y

ENV PATH=$PATH:/project/sawtooth-seth/bin:/root/.cargo/bin:/protoc3/bin:/project/sawtooth-seth/rpc/bin \
    CARGO_INCREMENTAL=0

RUN /root/.cargo/bin/cargo install cargo-deb

COPY . /project

WORKDIR /project/rpc

RUN export VERSION=$(../bin/get_version) \
 && sed -i -e "0,/version.*$/ s/version.*$/version\ =\ \"${VERSION}\"/" Cargo.toml \
 && /root/.cargo/bin/cargo deb --deb-version $VERSION

# -------------=== seth rpc docker build ===-------------

FROM ubuntu:bionic

RUN mkdir /debs

COPY --from=0 /project/target/debian/sawtooth-seth-rpc_*amd64.deb /debs

RUN apt-get update \
 && dpkg -i /debs/sawtooth-seth-rpc_*amd64.deb || true \
 && apt-get -f -y install \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
