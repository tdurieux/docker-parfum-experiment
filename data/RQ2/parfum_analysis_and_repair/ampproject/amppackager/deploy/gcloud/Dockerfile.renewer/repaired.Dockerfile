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

# Used https://medium.com/@chemidy/create-the-smallest-and-secured-golang-docker-image-based-on-scratch-4752223b7324
# as a guide.

# Use an official Go runtime as a parent image
FROM golang:1.16 as builder

ENV GO111MODULE=on

# Install git.
# Git is required for fetching the dependencies.
RUN apt-get update \
    && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

WORKDIR /data

# Run this if you clone from main branch.
RUN git clone -b main https://github.com/ampproject/amppackager.git /data/amppackager
# RUN git clone https://github.com/ampproject/amppackager.git /data/amppackager

WORKDIR /data/amppackager/cmd/amppkg

# Build the binary.
# See: https://medium.com/on-docker/use-multi-stage-builds-to-inject-ca-certs-ad1e8f01de1b
#      https://github.com/kelseyhightower/contributors
# Avoid "x509: failed to load system roots and no roots provided" by bundling root certificates.
# Avoid dynamic linking by using the pure Go net package (-tags netgo)
# Avoid dynamic linking by disabling cgo (CGO_ENABLED=0)
# Reduce binary size by omitting dwarf information (-ldflags '-w')
RUN CGO_ENABLED=0 GOOS=linux go build -a -tags netgo -ldflags '-w' -o /go/bin/amppkg

FROM alpine:latest as certs

RUN apk --update --no-cache add ca-certificates

# Build a small executable from docker alpine. Docker alpine is needed because
# bash is required to be present by the deployer as it prints the env variables
# listed below for verifiying the docker image
FROM alpine:latest

ENV PATH=/bin

# Copy the certs from the certs image.
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

# Copy the AMP packager binary into our app dir inside the container.
COPY --from=builder /go/bin/amppkg .

# Make port 8080 available to the world outside this container. This
# port must match the AMP Packager port configured in the toml file.
EXPOSE 8080

ENV PATH=$PATH:.

# This env var is used by click-to-deploy deployer, right now needs to be
# manually synced with C2D_RELEASE in the other Docker images for AMP Packager
# Deployer currently in https://github.com/banaag/click-to-deploy but will move
# to https://github.com/GoogleCloudPlatform/click-to-deploy.
ENV C2D_RELEASE=0.0.1

# Start the AMP Packager
ENTRYPOINT ["amppkg"]

# Set default flags to run in autorenew cert mode.
CMD ["-autorenewcert", "-config=/renewer/amppkg_renewer.toml"]

