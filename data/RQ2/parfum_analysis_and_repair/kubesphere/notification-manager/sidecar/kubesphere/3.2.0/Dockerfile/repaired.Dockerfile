# Use of this source code is governed by a Apache license
# that can be found in the LICENSE file.

FROM golang:1.16 as tenant-sidecar

COPY / /
COPY pkg/ pkg/
WORKDIR /
#ENV GOPROXY=https://goproxy.io