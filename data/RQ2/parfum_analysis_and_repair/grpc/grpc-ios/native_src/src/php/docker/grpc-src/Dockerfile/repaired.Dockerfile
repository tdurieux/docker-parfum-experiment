# Copyright 2019 gRPC authors.
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

FROM php:7.2-stretch

RUN apt-get -qq update && apt-get -qq -y upgrade && apt-get -qq --no-install-recommends install -y \
  autoconf automake git libtool pkg-config \
  valgrind wget zlib1g-dev && rm -rf /var/lib/apt/lists/*;

ARG MAKEFLAGS=-j8


WORKDIR /tmp

RUN wget https://phar.phpunit.de/phpunit-8.5.13.phar && \
  mv phpunit-8.5.13.phar /usr/local/bin/phpunit && \
  chmod +x /usr/local/bin/phpunit


WORKDIR /github/grpc

COPY . .

RUN make shared_c static_c


WORKDIR /github/grpc/src/php/ext/grpc

RUN phpize && \
  GRPC_LIB_SUBDIR=libs/opt ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-grpc=/github/grpc --enable-tests && \
  make && \
  make install


CMD ["/github/grpc/src/php/bin/run_tests.sh"]
