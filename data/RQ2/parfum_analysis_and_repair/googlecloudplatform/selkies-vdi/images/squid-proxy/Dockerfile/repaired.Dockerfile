# Copyright 2019 Google LLC
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

FROM docker.io/salrashid123/squidproxy

RUN apt-get -y update && \
    apt-get install --no-install-recommends -y \
        autotools-dev \
        automake \
        libtool-bin \
        iptables && rm -rf /var/lib/apt/lists/*;

WORKDIR /apps/
RUN git clone https://github.com/measurement-factory/squid.git -b SQUID-360-peering-for-SslBump squid-peer-ssl-bump \
    && CPU=$(( `nproc --all`-1 )) \
    && cd /apps/squid-peer-ssl-bump/ \
    && ./bootstrap.sh \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/apps/squid --enable-icap-client --enable-ssl --with-openssl --enable-ssl-crtd --enable-auth --enable-basic-auth-helpers="NCSA" --with-default-user=proxy \
    && make -j$CPU \
    && make install \
    && cd /apps \
    && rm -rf /apps/squid-peer-ssl-bump
