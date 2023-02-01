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

FROM golang:1.17-alpine as builder

WORKDIR /build
COPY . .
RUN mkdir /out

ENV CGO_ENABLED 0
ENV GOOS linux
ENV GO111MODULE on

RUN go mod download
RUN go build -o /out/wrapper.amd64 ./cmd/wrapper/main.go
RUN GOARCH=arm64 go build -o /out/wrapper.arm64 ./cmd/wrapper/main.go
# Setting the windows file names to respect 8.3 file naming.