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

# docker build -f ias_client/Dockerfile-installed-xenial -t sawtooth-ias-client .

# -------------=== ias_client build ===-------------

FROM ubuntu:xenial as ias-client-builder

ENV VERSION=AUTO_STRICT

RUN echo "deb [arch=amd64] http://repo.sawtooth.me/ubuntu/bumper/nightly xenial universe" >> /etc/apt/sources.list \
 && (apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 44FC67F19B2466EA \
 || apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 44FC67F19B2466EA) \
 && apt-get update \
 && apt-get install --no-install-recommends -y -q --allow-downgrades \
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

# -------------=== ias_client docker build ===-------------

FROM ubuntu:xenial

COPY --from=ias-client-builder /project/python3-sawtooth-ias-client*.deb /tmp

RUN echo "deb [arch=amd64] http://repo.sawtooth.me/ubuntu/bumper/nightly xenial universe" >> /etc/apt/sources.list \
 && (apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 44FC67F19B2466EA \
 || apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 44FC67F19B2466EA) \
 && apt-get update \
 && dpkg -i /tmp/python3-sawtooth-*.deb || true \
 && apt-get -f -y install \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
