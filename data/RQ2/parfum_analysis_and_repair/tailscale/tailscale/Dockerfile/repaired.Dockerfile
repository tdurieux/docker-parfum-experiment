# Copyright (c) 2020 Tailscale Inc & AUTHORS All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

############################################################################
#
# WARNING: Tailscale is not yet officially supported in container
# environments, such as Docker and Kubernetes. Though it should work, we
# don't regularly test it, and we know there are some feature limitations.
#
# See current bugs tagged "containers":
#    https://github.com/tailscale/tailscale/labels/containers
#
############################################################################

# This Dockerfile includes all the tailscale binaries.
#
# To build the Dockerfile:
#
#     $ docker build -t tailscale/tailscale .
#
# To run the tailscaled agent:
#
#     $ docker run -d --name=tailscaled -v /var/lib:/var/lib -v /dev/net/tun:/dev/net/tun --network=host --privileged tailscale/tailscale tailscaled
#
# To then log in:
#
#     $ docker exec tailscaled tailscale up
#
# To see status:
#
#     $ docker exec tailscaled tailscale status


FROM golang:1.18-alpine AS build-env

WORKDIR /go/src/tailscale

COPY go.mod go.sum ./
RUN go mod download

# Pre-build some stuff before the following COPY line invalidates the Docker cache.
RUN go install \
    github.com/aws/aws-sdk-go-v2/aws \
    github.com/aws/aws-sdk-go-v2/config \
    gvisor.dev/gvisor/pkg/tcpip/adapters/gonet \
    gvisor.dev/gvisor/pkg/tcpip/stack \
    golang.org/x/crypto/ssh \
    golang.org/x/crypto/acme \
    nhooyr.io/websocket \
    github.com/mdlayher/netlink \
    golang.zx2c4.com/wireguard/device

COPY . .

# see build_docker.sh