# Copyright © 2020 The OpenEBS Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# This Dockerfile builds a recent base image containing cstor binaries and
# libraries.
#

FROM openebs/arm64v8-ubuntu:xenial-20200326

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \ 
    apt-get update && apt-get install --no-install-recommends -y \
    curl tcpdump dnsutils iputils-ping \
    libaio1 libaio-dev \
    libssl1.0.0 rsyslog net-tools gdb apt-utils \
    sed libjemalloc-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install apt-file && apt-file update && rm -rf /var/lib/apt/lists/*;

COPY zfs/bin/* /usr/local/bin/
COPY zfs/lib/* /usr/lib/

ARG ARCH
ARG DBUILD_DATE
ARG DBUILD_REPO_URL
ARG DBUILD_SITE_URL

LABEL org.label-schema.name="cstor"
LABEL org.label-schema.description="OpenEBS cStor"
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$DBUILD_DATE
LABEL org.label-schema.vcs-url=$DBUILD_REPO_URL
LABEL org.label-schema.url=$DBUILD_SITE_URL

EXPOSE 7676
