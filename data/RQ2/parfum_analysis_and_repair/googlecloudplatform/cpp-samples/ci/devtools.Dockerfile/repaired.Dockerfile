# Copyright 2021 Google LLC
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

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update \
    && apt install --no-install-recommends -y build-essential git gcc g++ clang llvm cmake ninja-build pkg-config python3 tar zip unzip curl && rm -rf /var/lib/apt/lists/*;

RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | \
    tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl -f -sSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - \
    && apt-get update -y \
    && apt-get install --no-install-recommends google-cloud-sdk -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/local/vcpkg
# Pin vcpkg to the latest released version. Renovatebot sends PRs when there is a new release.
RUN curl -f -sSL "https://github.com/Microsoft/vcpkg/archive/2022.06.15.tar.gz" | \
    tar --strip-components=1 -zxf - \
    && ./bootstrap-vcpkg.sh \
    && /usr/local/vcpkg/vcpkg fetch cmake \
    && /usr/local/vcpkg/vcpkg fetch ninja
