# Copyright 2020 Wayback Archiver. All rights reserved.
# Use of this source code is governed by the GNU GPL v3
# license that can be found in the LICENSE file.
#
FROM golang:1.18-alpine AS builder

RUN apk update && apk add --no-cache build-base ca-certificates git
# Required by statically linked binary with OpenSSL
# RUN apk add linux-headers