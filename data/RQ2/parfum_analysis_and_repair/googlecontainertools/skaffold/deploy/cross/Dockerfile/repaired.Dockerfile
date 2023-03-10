# Copyright 2019 The Skaffold Authors All rights reserved.
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

FROM dockercore/golang-cross:1.13.15 as base

# Allow overriding the go toolchain version as required, though dockercore/golang-cross
# only supports up to macOS 10.10, and Go 1.15 requires a later version.
ARG GO_VERSION=1.14.14

# The base image is not yet available for go 1.15.
# Let's just replace the Go that's installed with a newer one.
RUN rm -Rf /usr/local/go && mkdir /usr/local/go
RUN curl --fail --show-error --silent --location https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz \
    | tar xz --directory=/usr/local/go --strip-components=1

# Cross compile Skaffold for Linux, Windows and MacOS