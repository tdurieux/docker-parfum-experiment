# Copyright 2020-2021 Alibaba Group Holding Limited.
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

FROM docker.pkg.github.com/v6d-io/v6d/vineyardd-alpine-builder:20210929 as builder

# target: docker.pkg.github.com/v6d-io/v6d/vineyardd:alpine-latest

ADD . /work/v6d

# FIXME It is still not clear why the first run of cmake will fail.

# patch cpprestsdk to drop boost::regex dependency.
RUN cd /work/v6d && \
    sed -i 's/Boost::regex//g' thirdparty/cpprestsdk/Release/cmake/cpprest_find_boost.cmake && \
    sed -i 's/regex//g' thirdparty/cpprestsdk/Release/cmake/cpprest_find_boost.cmake

RUN cd /tmp && \
    curl -f -LO https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 && \
    chmod +x dumb-init_1.2.2_amd64 && \
    curl -f -LO https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && \
    chmod +x wait-for-it.sh && \
    curl -f -LO https://github.com/etcd-io/etcd/releases/download/v3.4.13/etcd-v3.4.13-linux-amd64.tar.gz && \
    tar zxvf etcd-v3.4.13-linux-amd64.tar.gz && \
    cd /work/v6d && \
    mkdir -p /work/v6d/build && \
    cd /work/v6d/build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release \
         -DBUILD_SHARED_LIBS=OFF \
         -DUSE_STATIC_BOOST_LIBS=ON \
         -DBUILD_VINEYARD_SERVER=ON \
         -DBUILD_VINEYARD_CLIENT=OFF \
         -DBUILD_VINEYARD_PYTHON_BINDINGS=OFF \
         -DBUILD_VINEYARD_PYPI_PACKAGES=OFF \
         -DBUILD_VINEYARD_BASIC=OFF \
         -DBUILD_VINEYARD_GRAPH=OFF \
         -DBUILD_VINEYARD_IO=OFF \
         -DBUILD_VINEYARD_MIGRATION=OFF \
         -DBUILD_VINEYARD_TESTS=OFF \
         -DBUILD_VINEYARD_TESTS_ALL=OFF \
         -DBUILD_VINEYARD_PROFILING=OFF && \
    make -j`nproc` && \
    strip ./bin/vineyardd && rm etcd-v3.4.13-linux-amd64.tar.gz

FROM frolvlad/alpine-glibc:alpine-3.12

RUN apk add --no-cache bash sudo

COPY --from=builder /tmp/dumb-init_1.2.2_amd64 /usr/bin/dumb-init
COPY --from=builder /tmp/wait-for-it.sh /usr/bin/wait-for-it.sh
COPY --from=builder /tmp/etcd-v3.4.13-linux-amd64/etcd /usr/bin/etcd
COPY --from=builder /work/v6d/build/bin/vineyardd /usr/local/bin/vineyardd

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/usr/local/bin/vineyardd"]
