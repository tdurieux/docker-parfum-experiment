# Copyright 2019 Intel Corporation
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
# -----------------------------------------------------------------------------

FROM ubuntu:bionic

RUN apt-get update \
 && apt-get install --no-install-recommends gnupg -y && rm -rf /var/lib/apt/lists/*;

RUN \
 apt-get install --no-install-recommends -y -q \
    apt-transport-https \
    build-essential \
    ca-certificates \
    maven \
    default-jre \
    default-jdk \
    git \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*


EXPOSE 4004/tcp

WORKDIR /project/simplewallet/javaprocessor

CMD bash -c "./build_java_processor.sh"
