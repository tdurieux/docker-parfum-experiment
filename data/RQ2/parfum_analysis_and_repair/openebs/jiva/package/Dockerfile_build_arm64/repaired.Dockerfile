# Copyright © 2020 The OpenEBS Authors
#
# This file was originally authored by Rancher Labs
# under Apache License 2018.
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

#Make the base image configurable. If BASE IMAGES is not provided
#docker command will fail
ARG BASE_IMAGE=arm64v8/ubuntu:18.04

FROM $BASE_IMAGE

RUN apt-get update && apt-get install --no-install-recommends -y curl \
    && rm -rf /var/lib/apt/lists/*

COPY longhorn jivactl launch copy-binary launch-with-vm-backing-file launch-simple-jiva /usr/local/bin/

ARG ARCH
ARG DBUILD_DATE
ARG DBUILD_REPO_URL
ARG DBUILD_SITE_URL

LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name="jiva"
LABEL org.label-schema.description="OpenEBS Jiva"
LABEL org.label-schema.build-date=$DBUILD_DATE
LABEL org.label-schema.vcs-url=$DBUILD_REPO_URL
LABEL org.label-schema.url=$DBUILD_SITE_URL

VOLUME /usr/local/bin
CMD ["longhorn"]
