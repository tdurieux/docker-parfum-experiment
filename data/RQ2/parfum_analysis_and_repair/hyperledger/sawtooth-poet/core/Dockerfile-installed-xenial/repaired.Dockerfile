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

# docker build -f core/Dockerfile-installed-xenial -t sawtooth-poet-core .

# -------------=== poet common build ===-------------

FROM ubuntu:xenial as poet-common-builder

ENV VERSION=AUTO_STRICT

RUN echo "deb [arch=amd64] http://repo.sawtooth.me/ubuntu/bumper/nightly xenial universe" >> /etc/apt/sources.list \
 && (apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 44FC67F19B2466EA \
 || apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 44FC67F19B2466EA) \
 && apt-get update \
 && apt-get install --no-install-recommends -y -q --allow-downgrades \
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


# -------------=== simulator build ===-------------

FROM ubuntu:xenial as poet-simulator-builder

ENV VERSION=AUTO_STRICT

RUN echo "deb [arch=amd64] http://repo.sawtooth.me/ubuntu/bumper/nightly xenial universe" >> /etc/apt/sources.list \
 && (apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 44FC67F19B2466EA \
 || apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 44FC67F19B2466EA) \
 && apt-get update \
 && apt-get install --no-install-recommends -y -q --allow-downgrades \
    python3-cryptography >-1.7.1 \
    git \
    python3 \
    python3-sawtooth-sdk \
    python3-stdeb \
    python3-cryptography >=1.7.1 && rm -rf /var/lib/apt/lists/*;

COPY --from=poet-common-builder /project/python3-sawtooth-poet-common*.deb /tmp

COPY . /project

RUN dpkg -i /tmp/python3-sawtooth*.deb || true \
 && apt-get -f -y install \
 && cd /project/simulator \
 && if [ -d "debian" ]; then rm -rf debian; fi \
 && python3 setup.py clean --all \
 && python3 setup.py --command-packages=stdeb.command debianize \
 && if [ -d "packaging/ubuntu" ]; then cp -R packaging/ubuntu/* debian/; fi \
 && dpkg-buildpackage -b -rfakeroot -us -uc


# -------------=== poet core build ===-------------

FROM ubuntu:xenial as poet-core-builder

ENV VERSION=AUTO_STRICT

RUN echo "deb [arch=amd64] http://repo.sawtooth.me/ubuntu/bumper/nightly xenial universe" >> /etc/apt/sources.list \
 && (apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 44FC67F19B2466EA \
 || apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 44FC67F19B2466EA) \
 && apt-get update \
 && apt-get install --no-install-recommends -y -q --allow-downgrades \
    git \
    python3 \
    python3-cbor \
    python3-lmdb \
    python3-sawtooth-sdk \
    python3-requests \
    python3-stdeb && rm -rf /var/lib/apt/lists/*;

COPY --from=poet-common-builder /project/python3-sawtooth-poet-common*.deb /tmp
COPY --from=poet-simulator-builder /project/python3-sawtooth-poet-simulator*.deb /tmp

COPY . /project

RUN dpkg -i /tmp/python3-sawtooth*.deb || true \
 && apt-get -f -y install \
 && cd /project/core/ \
 && if [ -d "debian" ]; then rm -rf debian; fi \
 && python3 setup.py clean --all \
 && python3 setup.py --command-packages=stdeb.command debianize \
 && if [ -d "packaging/ubuntu" ]; then cp -R packaging/ubuntu/* debian/; fi \
 && dpkg-buildpackage -b -rfakeroot -us -uc


# -------------=== poet core docker build ===-------------

FROM ubuntu:xenial

COPY --from=poet-common-builder /project/python3-sawtooth-poet-common*.deb /tmp
COPY --from=poet-simulator-builder /project/python3-sawtooth-poet-simulator*.deb /tmp
COPY --from=poet-core-builder /project/python3-sawtooth-poet-core*.deb /tmp

RUN echo "deb [arch=amd64] http://repo.sawtooth.me/ubuntu/bumper/nightly xenial universe" >> /etc/apt/sources.list \
 && (apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 44FC67F19B2466EA \
 || apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 44FC67F19B2466EA) \
 && apt-get update \
 && dpkg -i /tmp/python3-sawtooth*.deb || true \
 && apt-get -f -y install \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
