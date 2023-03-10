#/*
#Copyright 2020 The OpenEBS Authors
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#	http://www.apache.org/licenses/LICENSE-2.0
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.
#*/
#
# This Dockerfile builds a recent cstor-volume-mgmt using the latest binary from
# cstor-volume-mgmt  releases.
#

#Make the base image configurable. If BASE IMAGES is not provided
##docker command will fail
ARG BASE_IMAGE=arm64v8/ubuntu:18.04
FROM $BASE_IMAGE

RUN apt-get update && apt-get -y --no-install-recommends install rsyslog && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /usr/local/etc/istgt

COPY cstor-volume-mgmt /usr/local/bin/
COPY entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/entrypoint.sh

ARG ARCH
ARG DBUILD_DATE
ARG DBUILD_REPO_URL
ARG DBUILD_SITE_URL

LABEL org.label-schema.name="cstor-volume-mgmt"
LABEL org.label-schema.description="Volume manager for cStor volumes"
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$DBUILD_DATE
LABEL org.label-schema.vcs-url=$DBUILD_REPO_URL
LABEL org.label-schema.url=$DBUILD_SITE_URL

ENTRYPOINT entrypoint.sh
EXPOSE 7676 7777
