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

ARG DISTRO_VERSION=8
FROM centos:${DISTRO_VERSION} AS devtools

## [START README.md]

# Install the development tools needed to compile the project:

# ```bash
RUN dnf makecache && \
    dnf install -y cmake gcc-c++ git make openssl-devel pkgconfig \
        zlib-devel
# ```

## [END README.md]