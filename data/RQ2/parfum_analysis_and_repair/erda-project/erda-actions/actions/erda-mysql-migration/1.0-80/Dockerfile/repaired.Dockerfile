# syntax = docker/dockerfile:1.2

# Copyright (c) 2021 Terminus, Inc.
#
# This program is free software: you can use, redistribute, and/or modify
# it under the terms of the GNU Affero General Public License, version 3
# or later ("AGPL"), as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

FROM golang:1.18 AS builder

COPY . /go/src/github.com/erda-project/erda-actions
WORKDIR /go/src/github.com/erda-project/erda-actions/actions
RUN rm -rf `ls | grep -v erda-mysql-migration`
WORKDIR /go/src/github.com/erda-project/erda-actions

# go mod tidy
RUN go env -w GOPROXY="https://goproxy.cn,direct"
RUN go env -w GOOS="linux"
RUN go env -w GOARCH="amd64"
RUN go mod tidy

# go build action cmd
RUN go build -o /opt/action/run actions/erda-mysql-migration/1.0-57/internal/action/cmd/main.go

# go build local cmd