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
FROM debian:buster
MAINTAINER dev@trafficcontrol.apache.org
ARG DIR=github.com/apache/trafficcontrol

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        # gcc is a CGO dependency
        gcc \
        # libc6-dev is a CGO dependency
        libc6-dev \
        wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY GO_VERSION /
RUN go_version=$(cat /GO_VERSION) && \
    wget -qO go.tar.gz https://dl.google.com/go/go${go_version}.linux-amd64.tar.gz && \
    tar -C /usr/local -xvzf go.tar.gz && \
    ln -s /usr/local/go/bin/go /usr/bin/go && \
    rm go.tar.gz
ENV GOPATH=/go
ENV PATH="${PATH}:${GOPATH}/bin"

ADD traffic_ops /go/src/$DIR/traffic_ops
ADD lib /go/src/$DIR/lib
ADD traffic_monitor /go/src/$DIR/traffic_monitor
ADD go.mod go.sum /go/src/$DIR/
ADD vendor /go/src/$DIR/vendor

WORKDIR /go/src/$DIR/traffic_ops/traffic_ops_golang

CMD bash -c 'go mod vendor -v && go test -cover -v ./... ../../lib/go-tc/...'
#
# vi:syntax=Dockerfile
