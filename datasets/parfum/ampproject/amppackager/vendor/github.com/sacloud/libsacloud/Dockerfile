#
# Copyright 2016-2020 The Libsacloud Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
FROM golang:1.12-alpine
LABEL maintainer="Kazumichi Yamamoto <yamamoto.febc@gmail.com>"

RUN apk add --no-cache --update ca-certificates git && \
    go get github.com/stretchr/testify/assert && \
    go get golang.org/x/tools/cmd/godoc && \
    go get -u github.com/golang/lint/golint

ENV SRC=$GOPATH/src/github.com/sacloud/libsacloud/
ADD . $SRC
WORKDIR $SRC

ENTRYPOINT [ "go" ]
CMD [ "test", "-v", "./..." ]
