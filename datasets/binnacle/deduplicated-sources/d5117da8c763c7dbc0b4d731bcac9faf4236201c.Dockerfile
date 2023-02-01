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
# under the License.
FROM quay.io/xhochy/arrow_manylinux1_x86_64_base:ARROW-2253

ADD arrow /arrow
WORKDIR /arrow/cpp
RUN mkdir build-plain
WORKDIR /arrow/cpp/build-plain
RUN cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/arrow-dist -DARROW_BUILD_TESTS=OFF -DARROW_BUILD_SHARED=ON -DARROW_BOOST_USE_SHARED=ON -DARROW_JEMALLOC=ON -DARROW_RPATH_ORIGIN=ON -DARROW_JEMALLOC_USE_SHARED=OFF -DBoost_NAMESPACE=arrow_boost -DBOOST_ROOT=/arrow_boost_dist ..
RUN ninja install

ADD scripts/check_arrow_visibility.sh /
RUN /check_arrow_visibility.sh

WORKDIR /
RUN git clone https://github.com/apache/parquet-cpp.git
WORKDIR /parquet-cpp
RUN ARROW_HOME=/arrow-dist cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/arrow-dist -DPARQUET_BUILD_TESTS=OFF -DPARQUET_BUILD_SHARED=ON -DPARQUET_BUILD_STATIC=OFF -DPARQUET_BOOST_USE_SHARED=ON -DBoost_NAMESPACE=arrow_boost -DBOOST_ROOT=/arrow_boost_dist -GNinja .
RUN ninja install
