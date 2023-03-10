# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License..


FROM ubuntu:18.04
MAINTAINER Yu Ding

ENV DEBIAN_FRONTEND=noninteractive
ENV VERSION         2.9.101.2-bionic1
ENV rust_toolchain  nightly-2020-10-25
ENV sdk_bin         https://download.01.org/intel-sgx/sgx-linux/2.9/distro/ubuntu18.04-server/sgx_linux_x64_sdk_2.9.101.2.bin

RUN apt-get update && \
    apt-get install --no-install-recommends -y gnupg2 apt-transport-https ca-certificates curl software-properties-common build-essential automake autoconf libtool protobuf-compiler libprotobuf-dev git-core libprotobuf-c0-dev cmake pkg-config expect gdb && \
    curl -fsSL https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key | apt-key add - && \
    add-apt-repository "deb https://download.01.org/intel-sgx/sgx_repo/ubuntu bionic main" && \
    apt-get update && \
    apt-get install --no-install-recommends -y \
        libsgx-aesm-launch-plugin=$VERSION \
        libsgx-enclave-common=$VERSION \
        libsgx-enclave-common-dbgsym=$VERSION \
        libsgx-enclave-common-dev=$VERSION \
        libsgx-epid=$VERSION \
        libsgx-epid-dbgsym=$VERSION \
        libsgx-epid-dev=$VERSION \
        libsgx-launch=$VERSION \
        libsgx-launch-dbgsym=$VERSION \
        libsgx-launch-dev=$VERSION \
        libsgx-quote-ex=$VERSION \
        libsgx-quote-ex-dbgsym=$VERSION \
        libsgx-quote-ex-dev=$VERSION \
        libsgx-uae-service=$VERSION \
        libsgx-uae-service-dbgsym=$VERSION \
        libsgx-urts=$VERSION \
        libsgx-urts-dbgsym=$VERSION && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/archives/* && \
    mkdir /var/run/aesmd && \
    mkdir /etc/init

RUN curl -f 'https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init' --output /root/rustup-init && \
    chmod +x /root/rustup-init && \
    echo '1' | /root/rustup-init --default-toolchain ${rust_toolchain} && \
    echo 'source /root/.cargo/env' >> /root/.bashrc && \
    /root/.cargo/bin/rustup component add rust-src rls rust-analysis clippy rustfmt && \
    /root/.cargo/bin/cargo install xargo && \
    rm /root/rustup-init && rm -rf /root/.cargo/registry && rm -rf /root/.cargo/git

RUN mkdir /root/sgx && \
    curl -f --output /root/sgx/sdk.bin ${sdk_bin} && \
    cd /root/sgx && \
    chmod +x /root/sgx/sdk.bin && \
    echo -e 'no\n/opt' | /root/sgx/sdk.bin && \
    echo 'source /opt/sgxsdk/environment' >> /root/.bashrc && \
    echo 'alias start-aesm="LD_LIBRARY_PATH=/opt/intel/sgx-aesm-service/aesm /opt/intel/sgx-aesm-service/aesm/aesm_service"' >> /root/.bashrc && \
    rm -rf /root/sgx*

WORKDIR /root