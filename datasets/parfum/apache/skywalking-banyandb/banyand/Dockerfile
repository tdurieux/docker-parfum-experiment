# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM golang:1.18 AS dev
WORKDIR /app
ENV GOOS="linux"
ENV CGO_ENABLED=0

RUN go install github.com/cosmtrek/air@latest \
    && go install github.com/go-delve/delve/cmd/dlv@latest

EXPOSE 8080
EXPOSE 2345

ENTRYPOINT ["air"]

FROM golang:1.18 AS base

ENV GOPATH "/go"
ENV GO111MODULE "on"
WORKDIR /src
COPY go.* ./
RUN go mod download
RUN GOBIN=/bin go install github.com/grpc-ecosystem/grpc-health-probe@v0.4.11 \
    && chmod 755 /bin/grpc-health-probe

FROM base AS builder

RUN --mount=target=. \
            --mount=type=cache,target=/root/.cache/go-build \
            BUILD_DIR=/out make -C banyand all

FROM alpine:edge AS certs
RUN apk add --no-cache ca-certificates
RUN update-ca-certificates

FROM busybox:stable-glibc

COPY --from=builder /out/banyand-server /banyand-server
COPY --from=certs /etc/ssl/certs /etc/ssl/certs

EXPOSE 17912
EXPOSE 17913

ENTRYPOINT ["/banyand-server"]

FROM busybox:stable-glibc AS test

COPY --from=builder /out/banyand-server /banyand-server
COPY --from=base /bin/grpc-health-probe /grpc-health-probe

EXPOSE 17912
EXPOSE 17913

ENTRYPOINT ["/banyand-server"]