# Copyright 2022 Google Inc. All Rights Reserved.
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

# Based on https://github.com/GoogleCloudPlatform/cloud-builders/blob/2c8cebc3e2dc28ac15b6e06f2887103e32a036ef/bazel/Dockerfile
# Keeps GCLIBC at version 2.28 since Golang Apache Beam only supports up to GLIBC version 2.29 in the harnes container as of 2022s0103


FROM debian:buster-20220125-slim

RUN \

    apt-get update && \
    apt-get -y upgrade && \
    apt-get -y --no-install-recommends install \
        python \
        python3 \
        python-pkg-resources \
        python3-pkg-resources \
        software-properties-common \
        unzip \
        git \
        curl \
        gnupg && rm -rf /var/lib/apt/lists/*;

RUN \

    apt-get -y --no-install-recommends install openjdk-11-jdk && rm -rf /var/lib/apt/lists/*;
RUN \
    echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list && \
    curl -f https://bazel.build/bazel-release.pub.gpg | apt-key add - && \
    apt-get update && \
    apt-get -y --no-install-recommends install bazel && \
    apt-get -y upgrade bazel && rm -rf /var/lib/apt/lists/*;

RUN \

    apt-get -y --no-install-recommends install \
        apt-transport-https \
        ca-certificates \
        lsb-release && rm -rf /var/lib/apt/lists/*;
RUN \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --batch --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get -y update && \
    apt-get install --no-install-recommends -y docker-ce docker-ce-cli && \
    apt-get -y autoclean && apt-get -y autoremove && rm -rf /var/lib/apt/lists/*;

    # Unpack bazel for future use.
RUN bazel version

# Store the Bazel outputs under /workspace so that the symlinks under bazel-bin (et al) are accessible
# to downstream build steps.
RUN mkdir -p /workspace
RUN echo 'startup --output_base=/workspace/.bazel' > ~/.bazelrc

ENTRYPOINT ["bazel"]
