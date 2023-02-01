# Copyright 2018-2019 Banco Bilbao Vizcaya Argentaria, S.A.

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM golang:1.12.5
# Allow cloning custom repo & branch for testing
ARG QED_REPO=https://github.com/bbva/qed.git
ARG QED_REPO_BRANCH=master

ENV REPO=${QED_REPO}
ENV BRANCH=${QED_REPO_BRANCH}

WORKDIR /go/src/github.com/bbva/qed
# Install deps.
RUN apt update -qq && apt install -qq -y autoconf cmake

# Download C deps. 
RUN echo Cloning repo: ${REPO} with branch: ${BRANCH}
RUN git clone --depth 1 -b ${BRANCH} ${REPO} .  &&\
    git submodule update --init --recursive

# Build C deps. 
RUN cd c-deps       &&\
    ./builddeps.sh

FROM golang:1.12.5
ARG BUILD_META=rc1

ENV GO111MODULE=on
ENV CGO_LDFLAGS_ALLOW='.*'

WORKDIR /go/src/github.com/bbva/qed

# Copy C deps form builder container
COPY --from=0 /go/src/github.com/bbva/qed/c-deps /tmp/c-deps

# Copy current source
COPY ./ .

# Download QED dependencies
RUN go mod download

# Move compiled c-deps
RUN rm -rf c-deps    &&\
    mv /tmp/c-deps .

# Build QED, Storage binary
RUN export BUILD_TAG=$(git rev-parse --abbrev-ref HEAD)           &&\
    export BUILD_COMMIT=$(git rev-parse HEAD)                     &&\
    export BUILD_DATE=$(date --utc +'%Y/%m/%dT%XUTC')             &&\
    go build -ldflags="-s -w                                        \
    -X github.com/bbva/qed/build.tag=${BUILD_TAG}                   \
    -X github.com/bbva/qed/build.rev=${BUILD_COMMIT}                \
    -X github.com/bbva/qed/build.utcTime=${BUILD_DATE}"             \
    -o /usr/local/bin/qed                                         &&\
    go build -o /usr/local/bin/storage testutils/notifierstore.go

# Clean
RUN rm -rf /var/lib/apt/lists/*

FROM ubuntu:19.10

COPY --from=1 /usr/local/bin/qed /usr/local/bin/qed
COPY --from=1 /usr/local/bin/storage /usr/local/bin/storage

RUN /usr/local/bin/qed generate signerkeys
