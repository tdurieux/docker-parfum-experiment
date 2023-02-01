#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#ubuntu:18.04 - linux; amd64
#https://github.com/docker-library/repo-info/blob/master/repos/ubuntu/tag-details.md#ubuntu1804---linux-amd64
FROM ubuntu@sha256:be159ff0e12a38fd2208022484bee14412680727ec992680b66cdead1ba76d19
# Set environment variables for apt to be noninteractive
ENV DEBIAN_FRONTEND "noninteractive"
ENV DEBCONF_NONINTERACTIVE_SEEN "true"
# shakedown and dcos-cli require this to output cleanly
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt-get update && apt-get install -y \
    curl \
    openjdk-8-jdk \
    groff \
    python3 \
    python3-pip \
    r-base \
    software-properties-common \
    git \
    && rm -rf /var/lib/apt/lists/*

# install Go and SBT
RUN add-apt-repository -y ppa:longsleep/golang-backports \
    && echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823 \
    && apt-get update && apt-get install -y \ 
    sbt \
    golang-go \
    && rm -rf /var/lib/apt/lists/*

# AWS CLI for uploading build artifacts
RUN pip3 install awscli
# Install dcos-launch to create clusters for integration testing
RUN curl -L -o /usr/bin/dcos-launch https://downloads.dcos.io/dcos-launch/bin/linux/dcos-launch \
    && chmod +x /usr/bin/dcos-launch

