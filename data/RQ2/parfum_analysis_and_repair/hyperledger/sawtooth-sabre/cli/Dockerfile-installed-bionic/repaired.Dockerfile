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

# docker build -f cli/Dockerfile-installed-bionic -t sawtooth-sabre-cli .

# -------------=== sabre cli build ===-------------

FROM ubuntu:bionic as sabre-cli-builder

ENV VERSION=AUTO_STRICT

RUN apt-get update \
  && apt-get install --no-install-recommends gnupg -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get update \
 && apt-get install --no-install-recommends -y \
 curl \
 gcc \
 git \
 libssl-dev \
 libzmq3-dev \
 pkg-config \
 python3 \
 unzip && rm -rf /var/lib/apt/lists/*;

# For Building Protobufs
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y \
 && curl -f -OLsS https://github.com/google/protobuf/releases/download/v3.5.1/protoc-3.5.1-linux-x86_64.zip \
 && unzip protoc-3.5.1-linux-x86_64.zip -d protoc3 \
 && rm protoc-3.5.1-linux-x86_64.zip

ENV PATH=$PATH:/protoc3/bin  \
    CARGO_INCREMENTAL=0
RUN /root/.cargo/bin/cargo install cargo-deb

COPY . /project

WORKDIR /project/cli

RUN export VERSION=$(../bin/get_version) \
 && sed -i -e "0,/version.*$/ s/version.*$/version\ =\ \"$(../bin/get_version)\"/" Cargo.toml \
 && /root/.cargo/bin/cargo deb --deb-version $VERSION

# -------------=== sabre cli docker build ===-------------

FROM hyperledger/sawtooth-shell:nightly

COPY --from=sabre-cli-builder /project/cli/target/debian/sabre-cli*.deb /tmp

RUN apt-get update \
 && dpkg --unpack /tmp/sabre-cli_*.deb \
 && apt-get -f -y install

ENTRYPOINT ["tail", "-f", "/dev/null"]
