# Copyright 2019 Gravitational, Inc.
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
ARG BASE_IMAGE
ARG BUILD_IMAGE
ARG BUILD_VERSION
ARG RIGGING_IMAGE

FROM $BUILD_IMAGE as build
ADD ./ /go/src/github.com/gravitational/satellite/
RUN cd /go/src/github.com/gravitational/satellite/ && BUILD_VERSION=${BUILD_VERSION} go run mage.go build:nethealth

#
# Build nethealth container
#