# Copyright 2016 Google Inc.
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

FROM gcr.io/oss-fuzz-base/base-builder
MAINTAINER mattkwong@google.com

RUN apt-get update && apt-get install -y software-properties-common python-software-properties
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update && apt-get -y install  \
	vim             \
	build-essential \
	openjdk-8-jdk   \
	make            \
        curl            \
        autoconf        \
        libtool

# Install Bazel
RUN echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list
RUN curl https://bazel.build/bazel-release.pub.gpg | apt-key add -
RUN apt-get update && apt-get install -y bazel
# Downgrade Bazel to 0.4.4
# Installing Bazel via apt-get first is required before installing 0.4.4 to
# allow gRPC to build without errors
RUN curl -fSsL -O https://github.com/bazelbuild/bazel/releases/download/0.4.4/bazel-0.4.4-installer-linux-x86_64.sh
RUN chmod +x ./bazel-0.4.4-installer-linux-x86_64.sh
RUN ./bazel-0.4.4-installer-linux-x86_64.sh

RUN git clone --recursive https://github.com/grpc/grpc grpc
WORKDIR /src/grpc/
COPY build.sh $SRC/
