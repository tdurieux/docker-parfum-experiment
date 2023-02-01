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

ARG BASE_IMAGE_VERSION=latest

ARG DATASKETCHES_CPP_HASH=8135b65408947694e13bd131038889e439847aa2
ARG DATASKETCHES_CPP_VERSION=3.4.0

FROM postgres:$BASE_IMAGE_VERSION

MAINTAINER dev@datasketches.apache.org

ENV APACHE_DIST_URLS \
  https://www.apache.org/dyn/closer.cgi?action=download&filename= \
  https://www-us.apache.org/dist/ \
  https://www.apache.org/dist/ \
  https://archive.apache.org/dist/

ARG DATASKETCHES_CPP_VERSION
ARG DATASKETCHES_CPP_HASH

ENV DS_CPP_VER=$DATASKETCHES_CPP_VERSION
ENV DS_CPP_HASH=$DATASKETCHES_CPP_HASH


ADD . /datasketches-postgresql
WORKDIR /datasketches-postgresql

RUN echo "===> Adding prerequisites..."                      && \
    export PG_MAJOR=`apt list --installed 2>&1 | sed -n "s/^postgresql-\([0-9.]*\)\/.*/\1/p"`             && \
    export PG_MINOR=`apt list --installed 2>&1 | sed -n "s/^postgresql-$PG_MAJOR\/\S*\s\(\S*\)\s.*/\1/p"` && \
    apt-get update -y                                        && \
    DEBIAN_FRONTEND=noninteractive                              \
        apt-get install --no-install-recommends --allow-downgrades -y -q \
                ca-certificates                                 \
                build-essential wget unzip                      \
                libboost-all-dev                                \
                postgresql-server-dev-$PG_MAJOR                 \
                libpq-dev                                    && \
    \
    \                
    echo "===> Building datasketches..."                     && \
    set -eux;                                                   \
    download_bin() {                                            \
        local f="$1"; shift;                                    \
        local hash="$1"; shift;                                 \
        local distFile="$1"; shift;                             \
        local success=;                                         \
        local distUrl=;                                         \
        for distUrl in $APACHE_DIST_URLS; do                    \
          if wget -nv -O "$f" "$distUrl$distFile"; then         \
            success=1;                                          \
            # Checksum the download                             \