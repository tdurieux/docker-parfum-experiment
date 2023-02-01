#
# Copyright 2019 GridGain Systems, Inc. and Contributors.
#
# Licensed under the GridGain Community Edition License (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.gridgain.com/products/software/community-edition/gridgain-community-edition-license
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    build-essential \
    default-jdk \
    libssl1.0-dev \
    unixodbc-dev \
    libboost-all-dev \
    libtool \
    automake \
    autoconf && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/ignite_cpp

COPY . .

RUN libtoolize && \
    aclocal && \
    autoheader && \
    automake --add-missing && \
    autoreconf && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-core --disable-thin-client --disable-node --disable-tests --enable-odbc && \
    make -j8 && \
    make install

WORKDIR /usr/src/ignite_cpp/odbc/install

RUN odbcinst -i -d -f ./ignite-odbc-install.ini -v

WORKDIR /usr/src/ignite_cpp/benchmarks

RUN libtoolize && \
    aclocal && \
    autoheader && \
    automake --add-missing && \
    autoreconf && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make -j8

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

WORKDIR /usr/src/ignite_cpp/benchmarks/odbc-sql

ENTRYPOINT ["./ignite-odbc-sql-benchmark"]
