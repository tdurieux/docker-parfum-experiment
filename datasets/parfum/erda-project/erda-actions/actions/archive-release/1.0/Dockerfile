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

FROM registry.erda.cloud/retag/golang:1.15 AS builder

COPY . /go/src/github.com/erda-project/erda-actions
WORKDIR /go/src/github.com/erda-project/erda-actions

# go build
ENV GOPROXY=https://goproxy.io,https://goproxy.cn,direct
RUN GOOS=linux GOARCH=amd64 go build -o /opt/action/run actions/archive-release/1.0/internal/cmd/main.go

FROM registry.erda.cloud/erda/terminus-centos:base

MAINTAINER chenzhongrun "zhongrun.czr@alibaba-inc.com"

COPY --from=builder /opt/action/run /opt/action/run

RUN chmod 777 /opt/action/*
