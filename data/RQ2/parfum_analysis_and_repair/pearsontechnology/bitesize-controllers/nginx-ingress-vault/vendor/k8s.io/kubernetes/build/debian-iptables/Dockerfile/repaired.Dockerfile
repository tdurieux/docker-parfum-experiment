# Copyright 2016 The Kubernetes Authors.
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

FROM BASEIMAGE

# If we're building for another architecture than amd64, the CROSS_BUILD_ placeholder is removed so e.g. CROSS_BUILD_COPY turns into COPY
# If we're building normally, for amd64, CROSS_BUILD lines are removed
CROSS_BUILD_COPY qemu-ARCH-static /usr/bin/

# All apt-get's must be in one run command or the
# cleanup has no effect.
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y iptables \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y ebtables \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y conntrack \
    && rm -rf /var/lib/apt/lists/*
