# Copyright 2015 The Kubernetes Authors. All rights reserved.
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

FROM debian:jessie
MAINTAINER Brendan B <bburns@google.com>

# so apt-get doesn't complain
ENV DEBIAN_FRONTEND=noninteractive

RUN \
  apt-get update && \
  apt-get install --no-install-recommends -y ca-certificates && \
  rm -rf /var/lib/apt/lists/*

ADD server server
ADD run.sh /run.sh
ENTRYPOINT ["/run.sh"]
