# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################################

FROM gcr.io/oss-fuzz-base/base-builder-jvm

RUN apt-get update && apt-get install --no-install-recommends -y make autoconf automake libtool pkg-config && rm -rf /var/lib/apt/lists/*;

RUN curl -f -L https://downloads.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.zip -o maven.zip && \
    unzip maven.zip -d $SRC/maven && \
    rm -rf maven.zip

ENV MVN $SRC/maven/apache-maven-3.6.3/bin/mvn

RUN curl -f -L -O https://raw.githubusercontent.com/protobuf-c/protobuf-c/39cd58f5ff06048574ed5ce17ee602dc84006162/t/test-full.proto

RUN git clone --depth 1 --recursive https://github.com/protocolbuffers/protobuf.git

COPY build.sh $SRC
COPY ProtobufFuzzer.java $SRC

WORKDIR $SRC
