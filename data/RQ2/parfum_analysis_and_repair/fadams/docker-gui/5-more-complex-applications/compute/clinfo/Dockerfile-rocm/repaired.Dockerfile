#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

FROM debian:stretch-slim

RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    wget gnupg2 libnuma-dev clinfo && \
    wget -qO - https://repo.radeon.com/rocm/apt/debian/rocm.gpg.key | apt-key add - && \
    echo 'deb [arch=amd64] http://repo.radeon.com/rocm/apt/debian/ xenial main' > /etc/apt/sources.list.d/rocm.list && \
    apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends rocm-dev && \
    apt-get clean && \
    apt-get purge -y wget gnupg2 && \
    apt-get autoremove -y && \
	rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["clinfo"]

#-------------------------------------------------------------------------------
# Example usage
#
# Build the image
# docker build -t clinfo-rocm -f Dockerfile-rocm .

