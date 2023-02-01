# Copyright (c) 2020 Tigera, Inc. All rights reserved.
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
ARG QEMU_IMAGE=calico/go-build:v0.55
ARG UBI_IMAGE

FROM ${QEMU_IMAGE} as qemu

FROM --platform=linux/arm64 ${UBI_IMAGE} as ubi

# Enable non-native builds of this image on an amd64 hosts.
# This must be the first RUN command in this file!