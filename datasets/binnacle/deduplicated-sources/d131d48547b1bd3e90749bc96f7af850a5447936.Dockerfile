# Copyright 2019 The Morning Consult, LLC or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You may
# not use this file except in compliance with the License. A copy of the
# License is located at
#
#         https://www.apache.org/licenses/LICENSE-2.0
#
# or in the "license" file accompanying this file. This file is distributed
# on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
# express or implied. See the License for the specific language governing
# permissions and limitations under the License.

FROM golang:1.11.4

WORKDIR /go/src/github.com/morningconsult/docker-credential-vault-login

ARG TARGET_GOOS
ARG TARGET_GOARCH

COPY . .

ENV GOOS $TARGET_GOOS
ENV GOARCH $TARGET_GOARCH

RUN make

ENTRYPOINT "/bin/bash"
