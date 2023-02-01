# Build the mattermost operator
ARG BUILD_IMAGE=golang:1.17
ARG BASE_IMAGE=gcr.io/distroless/static:nonroot

FROM ${BUILD_IMAGE} as builder

WORKDIR /workspace
COPY . .

RUN mkdir -p licenses
COPY LICENSE /workspace/licenses

# Build