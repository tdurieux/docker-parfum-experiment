# Copyright 2020 Google Inc
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

# Docker: Google App Engine

FROM java:jre-alpine
MAINTAINER Alex Prikhodko <aprikhodko@google.com>

ENV CLOUDSDK_CORE_DISABLE_PROMPTS 1
ENV DATA_DIR "/opt/pubsub"
ENV HOST_PORT 8432

RUN apk add --no-cache curl bash python

# Install Google Cloud SDK