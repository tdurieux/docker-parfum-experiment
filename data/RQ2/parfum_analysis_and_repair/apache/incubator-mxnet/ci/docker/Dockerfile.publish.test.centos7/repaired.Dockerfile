# -*- mode: dockerfile -*-
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
#
# Dockerfile for CentOS 7 based publish artifacts tests.
#
# See docker-compose.yml for supported BASE_IMAGE ARGs and targets.

####################################################################################################
# The Dockerfile uses a dynamic BASE_IMAGE (for example centos:7,
# nvidia/cuda:10.2-cudnn7-devel-centos7 etc).
# On top of BASE_IMAGE we install all dependencies required for the tests of
# binary artifacts.
####################################################################################################
ARG BASE_IMAGE
FROM $BASE_IMAGE

WORKDIR /work/deps

# Install runtime dependencies for publish tests
# - make is used to run tests ci/publish/scala/test.sh
# - unzip is used to run org.apache.mxnetexamples.neuralstyle.NeuralStyleSuite
# - gcc to provide libgomp.so.1 (may want to drop this in the future and ship
#   inside jar)
# - rh-maven35 to run ci/publish/scala/test.sh
RUN yum -y check-update || true && \
    yum -y install epel-release centos-release-scl && \
    yum -y install \
        make \
        gcc \
        unzip \
        rh-maven35 && \
    yum clean all && rm -rf /var/cache/yum

ARG USER_ID=0
COPY install/docker_filepermissions.sh /work/
RUN /work/docker_filepermissions.sh

ENV PYTHONPATH=./python/
WORKDIR /work/mxnet

COPY runtime_functions.sh /work/
