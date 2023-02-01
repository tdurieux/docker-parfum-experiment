# Copyright 2019 Google LLC
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

FROM open-match-base-build as builder

WORKDIR /go/src/open-match.dev/open-match

ARG IMAGE_TITLE

RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    make "build/cmd/${IMAGE_TITLE}"

FROM gcr.io/distroless/static:nonroot
ARG IMAGE_TITLE
WORKDIR /app/

COPY --from=builder --chown=nonroot "/go/src/open-match.dev/open-match/build/cmd/${IMAGE_TITLE}/" "/app/"

ENTRYPOINT ["/app/run"]

# Docker Image Arguments
ARG BUILD_DATE
ARG VCS_REF
ARG BUILD_VERSION

# Standardized Docker Image Labels
# https://github.com/opencontainers/image-spec/blob/master/annotations.md