# Copyright 2020 Intel Corporation
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
# ------------------------------------------------------------------------------

FROM ubuntu:bionic

RUN apt update \
 && apt install --no-install-recommends -y -q \
    haproxy && rm -rf /var/lib/apt/lists/*;

COPY haproxy.cfg .

# Append front and back end load balancer configurations to existing
# file in /etc/haproxy/haproxy.cfg
RUN echo "$(cat haproxy.cfg)" >> /etc/haproxy/haproxy.cfg
