# Copyright 2018 Google, Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Builds the static Go image to execute in a Kubernetes job

FROM golang:1.10
WORKDIR /go/src/github.com/GoogleContainerTools/kaniko
COPY . .
RUN make out/warmer

FROM scratch
COPY --from=0 /go/src/github.com/GoogleContainerTools/kaniko/out/warmer /kaniko/warmer
COPY files/ca-certificates.crt /kaniko/ssl/certs/
ENV HOME /root
ENV USER /root
ENV PATH /usr/local/bin:/kaniko
ENV SSL_CERT_DIR=/kaniko/ssl/certs
ENV DOCKER_CONFIG /kaniko/.docker/
WORKDIR /workspace
ENTRYPOINT ["/kaniko/warmer"]
