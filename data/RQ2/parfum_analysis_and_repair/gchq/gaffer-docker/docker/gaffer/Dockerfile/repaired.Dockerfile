# Copyright 2020 Crown Copyright
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

ARG BUILDER_IMAGE_NAME=maven
ARG BUILDER_IMAGE_TAG=3.8.4-jdk-8

ARG BASE_IMAGE_NAME=gchq/accumulo
ARG BASE_IMAGE_TAG=1.9.3

FROM ${BUILDER_IMAGE_NAME}:${BUILDER_IMAGE_TAG} as builder

ARG GAFFER_VERSION=1.22.0
ARG GAFFER_LIBS=bitmap-library,sketches-library,time-library
ARG GAFFER_DOWNLOAD_URL=https://repo1.maven.org/maven2
ARG GAFFER_GIT_REPO=https://github.com/gchq/Gaffer.git

WORKDIR /jars

# Allow users to provide their own JAR files
COPY ./files/ .
# Try to download required version from Maven Central, otherwise build from source