# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

ARG BASE_IMAGE=ghcr.io/flowerfine/scaleph_flink:1.13.6_2.11

FROM $BASE_IMAGE

ARG SEATUNNEL_VERSION

ENV SEATUNNEL_HOME /opt/seatunnel
RUN mkdir -p $SEATUNNEL_HOME ; cd $SEATUNNEL_HOME ; \
    tar_file=apache-seatunnel-incubating-${SEATUNNEL_VERSION}-bin.tar.gz ; \
    curl -f -LSO https://archive.apache.org/dist/incubator/seatunnel/${SEATUNNEL_VERSION}/$tar_file; \
    tar -zxf $tar_file --strip 1 -C . ; \
    rm $tar_file