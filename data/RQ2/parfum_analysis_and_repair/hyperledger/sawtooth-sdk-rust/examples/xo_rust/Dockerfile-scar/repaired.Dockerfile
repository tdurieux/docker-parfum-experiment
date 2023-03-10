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

FROM ubuntu:bionic

# Install base dependencies

RUN apt-get update \
 && apt-get install --no-install-recommends -y \
 curl \
 gcc \
 libssl-dev \
 libzmq3-dev \
 pkg-config \
 unzip && rm -rf /var/lib/apt/lists/*;

ENV PATH=$PATH:/protoc3/bin:/root/.cargo/bin

# Install Rust
RUN curl https://sh.rustup.rs -sSf > /usr/bin/rustup-init \
 && chmod +x /usr/bin/rustup-init \
 && rustup-init -y

RUN rustup update \
 && rustup target add wasm32-unknown-unknown

# Install protoc
RUN curl -f -OLsS https://github.com/google/protobuf/releases/download/v3.7.1/protoc-3.7.1-linux-x86_64.zip \
 && unzip -o protoc-3.7.1-linux-x86_64.zip -d /usr/local \
 && rm protoc-3.7.1-linux-x86_64.zip

WORKDIR /build

# Create empty cargo project for xo tp
RUN mkdir examples \
 && USER=root cargo new --bin examples/xo_rust \
 && touch examples/xo_rust/src/lib.rs

# Copy over Cargo.toml file
COPY examples/xo_rust/Cargo.toml /build/examples/xo_rust/Cargo.toml

# Remove sawtooth-sdk dependency. Cargo still tries to build it
# despite it not being part of the conditional target.
WORKDIR /build/examples/xo_rust
RUN sed -i -e s/sawtooth-sdk.*// Cargo.toml

# Do a release build to cache dependencies
RUN cargo build --target wasm32-unknown-unknown --release

# Remove the auto-generated .rs files and the built files
RUN rm target/wasm32-unknown-unknown/release/xo-tp-rust* \
    target/wasm32-unknown-unknown/release/deps/xo* \
    target/wasm32-unknown-unknown/release/libsawtooth_xo.* \
    target/wasm32-unknown-unknown/release/deps/libsawtooth_xo*

# Copy over source files
COPY examples/xo_rust/src /build/examples/xo_rust/src

# Update the contract version
ARG REPO_VERSION
RUN sed -i -e "0,/version.*$/ s/version.*$/version\ =\ \"${REPO_VERSION}\"/" Cargo.toml

# Build the contract
RUN cargo build --target wasm32-unknown-unknown --release

# Copy the packaging directory
COPY examples/xo_rust/packaging/scar/* \
     /build/examples/xo_rust/packaging/scar/

# Copy the contract to the packaging directory
RUN cp target/wasm32-unknown-unknown/release/xo-tp-rust.wasm \
    packaging/scar

WORKDIR /build/examples/xo_rust/packaging/scar

# Create .scar file
RUN tar -jcvf /tmp/xo_${REPO_VERSION}.scar .
