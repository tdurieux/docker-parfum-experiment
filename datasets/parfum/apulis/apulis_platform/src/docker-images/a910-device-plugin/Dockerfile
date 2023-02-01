# Copyright 2020 Apulic, Inc.  All rights reserved.
# 
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
# 
#      http://www.apache.org/licenses/LICENSE-2.0
# 
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
FROM golang:1.13.7-alpine3.11
RUN apk --no-cache add git pkgconfig build-base
RUN mkdir -p /go/src/apulis/k8s-device-plugin
ADD . /go/src/apulis/k8s-device-plugin

RUN cd /go/src/apulis/k8s-device-plugin/cmd; GO111MODULE=${GO111MODULE} go build -o /go/bin/a910-device-plugin; cd /go

FROM alpine:3.11
MAINTAINER Andrew Su <andrew.su@apulis.com>
RUN apk --no-cache add ca-certificates libdrm
WORKDIR /root/
COPY --from=0 /go/bin/a910-device-plugin .
CMD ["./a910-device-plugin"]



