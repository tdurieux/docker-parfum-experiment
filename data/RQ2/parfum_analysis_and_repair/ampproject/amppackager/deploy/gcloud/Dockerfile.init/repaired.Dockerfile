# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM alpine:latest as certs

RUN apk --update --no-cache add ca-certificates

FROM debian:buster-slim as builder

# Git is required for fetching the dependencies.
RUN apt-get update \
    && apt-get install --no-install-recommends -y openssl \
    && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

WORKDIR /data

COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

COPY deploy.sh ./deploy.sh

COPY san_template.cnf ./san_template.cnf

COPY *.toml ./

# This env var is used by click-to-deploy deployer, right now needs to be
# manually synced with C2D_RELEASE in the other Docker images for AMP Packager
ENV C2D_RELEASE=0.0.1

CMD ["/bin/bash", "-c", "./deploy.sh"]]
