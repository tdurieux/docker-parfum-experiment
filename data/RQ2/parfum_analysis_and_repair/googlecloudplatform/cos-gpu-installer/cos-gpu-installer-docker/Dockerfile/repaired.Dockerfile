# Copyright 2017 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Dockerfile for the COS GPU Installer container.

FROM debian:9
LABEL maintainer="cos-containers@google.com"

# Install minimal tools needed to build kernel modules.
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends xz-utils python2.7-minimal \
    libc6-dev libpython2.7-stdlib kmod make curl ca-certificates libssl-dev \
    gcc libelf-dev keyutils && \
    rm -rf /var/lib/apt/lists/*

# Download & install prebuild COS toolchain package, and prepare the environment for cross-compiling.