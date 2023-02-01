#
# Copyright 2020 Alexander Vollschwitz
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

# Skopeo build, taken from https://github.com/bdwyertech/docker-skopeo
#
FROM golang:1.18.3-alpine3.15@sha256:a1c4b28a06d5fce9b1e52b09930e240d24b00dfa85879df023f2ea7201bbe026 as skopeo

ARG SKOPEO_VERSION

WORKDIR /go/src/github.com/containers/skopeo

RUN apk add --no-cache --virtual .build-deps \
        git build-base btrfs-progs-dev gpgme-dev linux-headers lvm2-dev \
    && git clone --single-branch --branch "${SKOPEO_VERSION}" \
        https://github.com/containers/skopeo.git . \
    && go build -ldflags="-s -w" -o bin/skopeo ./cmd/skopeo \
    && apk del .build-deps


# dregsy image
#