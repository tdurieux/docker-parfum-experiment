# Copyright 2019 Google LLC
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

#
# WARNING: This is an automatically generated file. Consider changing the
#     sources instead. You can find the source templates and scripts at:
#     https://github.com/googleapis/google-cloud-cpp-common/tree/master/ci/templates
#

ARG DISTRO_VERSION=bionic
FROM ubuntu:${DISTRO_VERSION} AS devtools

## [START README.md]

# Install the minimal development tools:

# ```bash
RUN apt-get update && \
    apt-get --no-install-recommends install -y apt-transport-https apt-utils \
        automake build-essential cmake ca-certificates git gcc g++ cmake \
        libc-ares-dev libc-ares2 libcurl4-openssl-dev libssl-dev m4 make \
        pkg-config tar wget zlib1g-dev && rm -rf /var/lib/apt/lists/*;
# ```

## [END README.md]

FROM devtools AS readme
ARG NCPU=4

WORKDIR /home/build/super
COPY . /home/build/super
RUN cmake -Hsuper -Bcmake-out \
        -DGOOGLE_CLOUD_CPP_EXTERNAL_PREFIX=$HOME/local
RUN cmake --build cmake-out -- -j ${NCPU:-4}
