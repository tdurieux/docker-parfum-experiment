# Copyright 2020 The Volcano Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM arm64v8/alpine:latest

# Install requirements for admission service
# Install requirements
ARG KUBE_VERSION="1.16.6"
RUN apk add --update ca-certificates && \
    apk add --update openssl && \
    apk add --update -t deps curl && \
    curl -f -L https://storage.googleapis.com/kubernetes-release/release/v$KUBE_VERSION/bin/linux/arm64/kubectl -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    apk del --purge deps && \
    rm /var/cache/apk/*
ENTRYPOINT []