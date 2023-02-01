# Copyright 2022 Google LLC
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

# This Dockerfile builds an image containing builds of all the binaries built
# from source (manager, webhook, etc.)
FROM golang:1.17 AS builder

ENV GOFLAGS "-mod=vendor"

# Copy in the Go source code
WORKDIR /go/src/github.com/GoogleCloudPlatform/k8s-config-connector
COPY pkg/    pkg/
COPY cmd/    cmd/
COPY vendor/ vendor/
COPY scripts/generate-third-party-licenses scripts/generate-third-party-licenses
COPY go.mod go.mod
COPY go.sum go.sum

# Build the binaries from source. Note: the "-s -w" flags strip the tables
# needed for debuggers, but not the line numbers for panics