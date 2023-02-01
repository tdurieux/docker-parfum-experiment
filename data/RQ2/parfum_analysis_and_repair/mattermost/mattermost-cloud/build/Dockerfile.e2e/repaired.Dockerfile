# Copyright (c) 2015-present Mattermost, Inc. All Rights Reserved.
# See LICENSE.txt for license information.

# Build the mattermost cloud e2e
ARG DOCKER_BUILD_IMAGE=golang:1.17
ARG DOCKER_BASE_IMAGE=alpine:3.14

FROM ${DOCKER_BUILD_IMAGE} AS build
WORKDIR /mattermost-cloud-e2e/
COPY go.mod .
COPY go.sum .
RUN go mod download
COPY . .

## TODO: We should also build other tests with either this or other dockerfiles,
## when they are ready to be run without infra dependencies

RUN CGO_ENABLED=0 go test -tags=e2e -c -ldflags="-s -w" -o mattermost-cloud-e2e-tests ./e2e/tests/cluster

# Final Image