# Copyright Amazon.com Inc. or its affiliates. All Rights Reserved.
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

ARG BASE_IMAGE
FROM $BASE_IMAGE as base

ARG TARGETARCH
ARG TARGETOS
ARG RELEASE_BRANCH

COPY _output/$RELEASE_BRANCH/bin/release-src/$TARGETOS-$TARGETARCH/go-runner /go-runner
COPY _output/$RELEASE_BRANCH/LICENSES /LICENSES
COPY $RELEASE_BRANCH/ATTRIBUTION.txt /ATTRIBUTION.txt

ENTRYPOINT ["/go-runner"]


FROM base as standard

ARG RELEASE_BRANCH

# Installing dependencies listed in upstream here: https://github.com/kubernetes/release/blob/master/images/build/debian-iptables/buster/Dockerfile
# Since we rely on AL2, necessary files from netbase are already included, and we aren't making the same optimizations as of now.