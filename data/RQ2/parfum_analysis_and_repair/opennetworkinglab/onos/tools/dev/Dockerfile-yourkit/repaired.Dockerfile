# Copyright 2021-present Open Networking Foundation
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

# With this dockerfile you can build a ONOS Docker container
# with YourKit profiler agent enabled

ARG JOBS=2
ARG PROFILE=default
ARG TAG=11.0.8-11.41.23
ARG JAVA_PATH=/usr/lib/jvm/zulu11-ca-amd64

# First stage is the build environment.
# zulu-openjdk images are based on Ubuntu.
FROM azul/zulu-openjdk:${TAG} as builder

# Define the profiler version to be used
ARG ONOS_YOURKIT

ENV BUILD_DEPS \
    ca-certificates \
    zip \
    python \
    python3 \
    git \
    bzip2 \
    build-essential \
    curl \
    unzip
RUN apt-get update && apt-get install --no-install-recommends -y ${BUILD_DEPS} && rm -rf /var/lib/apt/lists/*;

# Install Bazelisk, which will download the version of bazel specified in
# .bazelversion
RUN curl -f -L -o bazelisk https://github.com/bazelbuild/bazelisk/releases/download/v1.5.0/bazelisk-linux-amd64
RUN chmod +x bazelisk && mv bazelisk /usr/bin

# Build-stage environment variables
ENV ONOS_ROOT /src/onos
ENV BUILD_NUMBER docker
ENV JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8

# Copy in the sources
COPY . ${ONOS_ROOT}
WORKDIR ${ONOS_ROOT}

# Build ONOS using the JDK pre-installed in the base image, instead of the
# Bazel-provided remote one. By doing wo we make sure to build with the most
# updated JDK, including bug and security fixes, independently of the Bazel
# version.
ARG JOBS
ARG JAVA_PATH
ARG PROFILE
RUN bazelisk build onos \
    --jobs ${JOBS} \
    --verbose_failures \
    --javabase=@bazel_tools//tools/jdk:absolute_javabase \
    --host_javabase=@bazel_tools//tools/jdk:absolute_javabase \
    --define=ABSOLUTE_JAVABASE=${JAVA_PATH} \
    --define profile=${PROFILE}

# We extract the tar in the build environment to avoid having to put the tar in
# the runtime stage. This saves a lot of space.
RUN mkdir /output
RUN tar -xf bazel-bin/onos.tar.gz -C /output --strip-components=1 && rm bazel-bin/onos.tar.gz
# Get yourkit profiler and extract in the ONOS temp folder
RUN curl -f -L -o yourkit.zip https://www.yourkit.com/download/YourKit-JavaProfiler-$ONOS_YOURKIT.zip && \
    unzip -o yourkit.zip && \
    rm yourkit.zip && \
    mv YourKit-JavaProfiler-$(echo $ONOS_YOURKIT | sed 's/\(.*\)-.*/\1/')/bin/linux-x86-64/libyjpagent.so /output/libyjpagent.so

# Second and final stage is the runtime environment.
FROM azul/zulu-openjdk:${TAG}

LABEL org.label-schema.name="ONOS" \
      org.label-schema.description="SDN Controller" \
      org.label-schema.usage="http://wiki.onosproject.org" \
      org.label-schema.url="http://onosproject.org" \
      org.label-scheme.vendor="Open Networking Foundation" \
      org.label-schema.schema-version="1.0" \
      maintainer="onos-dev@onosproject.org"

RUN apt-get update && apt-get install --no-install-recommends -y curl && \
	rm -rf /var/lib/apt/lists/*

# Install ONOS in /root/onos
COPY --from=builder /output/ /root/onos/
WORKDIR /root/onos

# Set JAVA_HOME (by default not exported by zulu images)
ARG JAVA_PATH
ENV JAVA_HOME ${JAVA_PATH}
# Set ONOS_YOURKIT to enable the profiler agent
ENV ONOS_YOURKIT true

# Ports
# 6653 - OpenFlow
# 6640 - OVSDB
# 8181 - GUI
# 8101 - ONOS CLI
# 9876 - ONOS intra-cluster communication
# 10001-10010 - YourKit profiler
EXPOSE 6653 6640 8181 8101 9876 10001-10010

# Run ONOS
ENTRYPOINT ["./bin/onos-service"]
CMD ["server"]
