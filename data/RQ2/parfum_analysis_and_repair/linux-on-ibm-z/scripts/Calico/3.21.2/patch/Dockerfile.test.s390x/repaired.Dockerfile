# Copyright (c) 2015-2019 Tigera, Inc. All rights reserved.
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


# NOTE: This Dockerfile should be kept in-sync with the one in calico/node.
# This ensures that testing of Felix in this repository is done in the same
# userspace environment as it will be deployed in calico/node.
FROM calico/felix-wgtool:latest as wgtool

FROM calico/felix:latest-s390x
LABEL maintainer="Shaun Crampton <shaun@tigera.io>"

COPY --from=wgtool /usr/bin/wg /usr/bin/wg

# Install remaining runtime deps required for felix from the global repository
RUN apt-get update && apt-get install --no-install-recommends -y \

    wget \
    ethtool \
    tcpdump && rm -rf /var/lib/apt/lists/*;

ARG FV_BINARY=calico-felix-s390x

ADD test-connection test-workload pktgen  /
ADD $FV_BINARY /code/calico-felix
