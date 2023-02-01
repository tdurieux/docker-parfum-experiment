# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Use the official Docker Hub Ubuntu 20.04 base image
FROM ubuntu:20.04

# Update the base image
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt -y --no-install-recommends install apt-utils && apt -y upgrade && apt -y dist-upgrade && rm -rf /var/lib/apt/lists/*;

# Setup DFDewey dependencies
RUN apt -y --no-install-recommends install software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:gift/stable
RUN apt update
RUN apt -y --no-install-recommends install \
    bulk-extractor \
    libpq-dev \
    python3 \
    python3-pip \
    python3-dev \
    python3-dfvfs && rm -rf /var/lib/apt/lists/*;

# Setup dfDewey
ADD . /tmp/
RUN cd /tmp/ && python3 setup.py install
COPY docker/keepalive.sh /usr/bin/keepalive.sh
RUN chmod a+x /usr/bin/keepalive.sh

CMD ["/usr/bin/keepalive.sh"]
