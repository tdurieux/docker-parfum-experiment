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

# docker build -f sgx/Dockerfile-installed-bionic -t sawtooth-poet-sgx .

# -------------=== poet common build ===-------------

FROM ubuntu:bionic as poet-common-builder

ENV VERSION=AUTO_STRICT

RUN apt-get update \
 && apt-get install --no-install-recommends gnupg -y && rm -rf /var/lib/apt/lists/*;

RUN echo "deb [arch=amd64] http://repo.sawtooth.me/ubuntu/nightly bionic universe" >> /etc/apt/sources.list \
 && (apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 44FC67F19B2466EA \
 || apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 44FC67F19B2466EA) \
 && apt-get update \
 && apt-get install --no-install-recommends -y -q \
    git \
    python3 \
    python3-protobuf \
    python3-stdeb \
    python3-grpcio-tools \
    python3-grpcio && rm -rf /var/lib/apt/lists/*;

COPY . /project

RUN cd /project/common/ \
 && /project/bin/protogen \
 && if [ -d "debian" ]; then rm -rf debian; fi \
 && python3 setup.py clean --all \
 && python3 setup.py --command-packages=stdeb.command debianize \
 && if [ -d "packaging/ubuntu" ]; then cp -R packaging/ubuntu/* debian/; fi \
 && dpkg-buildpackage -b -rfakeroot -us -uc

# -------------=== ias_client build ===-------------

FROM ubuntu:bionic as ias-client-builder

ENV VERSION=AUTO_STRICT

RUN apt-get update \
 && apt-get install --no-install-recommends gnupg -y && rm -rf /var/lib/apt/lists/*;

RUN echo "deb [arch=amd64] http://repo.sawtooth.me/ubuntu/nightly bionic universe" >> /etc/apt/sources.list \
 && (apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 44FC67F19B2466EA \
 || apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 44FC67F19B2466EA) \
 && apt-get update \
 && apt-get install --no-install-recommends -y -q \
    git \
    python3 \
    python3-requests \
    python3-stdeb && rm -rf /var/lib/apt/lists/*;

COPY . /project

RUN cd /project/ias_client \
 && if [ -d "debian" ]; then rm -rf debian; fi \
 && python3 setup.py clean --all \
 && python3 setup.py --command-packages=stdeb.command debianize \
 && if [ -d "packaging/ubuntu" ]; then cp -R packaging/ubuntu/* debian/; fi \
 && dpkg-buildpackage -b -rfakeroot -us -uc

 # -------------=== poet sgx builder ===-------------

FROM ubuntu:bionic as poet-sgx-builder

ENV VERSION=AUTO_STRICT

RUN apt-get update \
 && apt-get install --no-install-recommends gnupg -y && rm -rf /var/lib/apt/lists/*;

RUN echo "deb [arch=amd64] http://repo.sawtooth.me/ubuntu/nightly bionic universe" >> /etc/apt/sources.list \
 && (apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 44FC67F19B2466EA \
 || apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 44FC67F19B2466EA) \
 && apt-get update \
 && apt-get install --no-install-recommends -y -q \
    build-essential \
    ca-certificates \
    cmake \
    dh-autoreconf \
    git \
    libcrypto++-dev \
    libjson-c-dev \
    make \
    python3-all-dev \
    python3-dev \
    python3-protobuf \
    python3-setuptools \
    python3-setuptools-scm \
    python3-stdeb \
    python3-toml \
    software-properties-common \
    swig3.0 \
    unzip \
    wget \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/swig3.0 /usr/bin/swig

# Install SGX SDK for PoET
WORKDIR /tmp

RUN wget https://download.01.org/intel-sgx/linux-2.0/sgx_linux_ubuntu16.04.1_x64_sdk_2.0.100.40950.bin \
 && chmod +x sgx_linux_ubuntu16.04.1_x64_sdk_2.0.100.40950.bin \
 && echo "yes" | ./sgx_linux_ubuntu16.04.1_x64_sdk_2.0.100.40950.bin\
 && . /tmp/sgxsdk/environment \
 && export SGXSDKInstallPath=/tmp/sgxsdk/ \
 && export POET_ENCLAVE_PEM=/tmp/sgxsdk/SampleCode/SampleEnclave/Enclave/Enclave_private.pem \
 && export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/project/sgx

COPY --from=poet-common-builder /project/python3-sawtooth-poet-common*.deb /tmp
COPY --from=ias-client-builder /project/python3-sawtooth-ias-client*.deb /tmp

RUN dpkg -i /tmp/python3-sawtooth-*.deb || true \
 && apt-get -f -y install

COPY . /project

RUN export SGXSDKInstallPath=/tmp/sgxsdk/ \
 && if [ -z ${POET_ENCLAVE_PEM+x} ]; then \
      export POET_ENCLAVE_PEM=/tmp/sgxsdk/SampleCode/SampleEnclave/Enclave/Enclave_private.pem; \
    fi \
 && cd  /project/sgx \
 && python3 setup.py clean --all \
 && python3 setup.py --command-packages=stdeb.command debianize \
 && if [ -d "packaging/ubuntu" ]; then cp -R packaging/ubuntu/* debian/; fi \
 && dpkg-buildpackage -b -rfakeroot -us -uc

 # -------------=== poet sgx docker build ===-------------

FROM ubuntu:bionic

RUN apt-get update \
 && apt-get install --no-install-recommends gnupg -y && rm -rf /var/lib/apt/lists/*;

COPY --from=poet-common-builder /project/python3-sawtooth-poet-common*.deb /tmp
COPY --from=ias-client-builder /project/python3-sawtooth-ias-client*.deb /tmp
COPY --from=poet-sgx-builder /project/python3-sawtooth-poet-sgx*.deb /tmp

RUN echo "deb [arch=amd64] http://repo.sawtooth.me/ubuntu/nightly bionic universe" >> /etc/apt/sources.list \
 && (apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 44FC67F19B2466EA \
 || apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 44FC67F19B2466EA) \
 && apt-get update \
 && dpkg -i /tmp/python3-sawtooth-*.deb || true \
 && apt-get -f -y install \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
