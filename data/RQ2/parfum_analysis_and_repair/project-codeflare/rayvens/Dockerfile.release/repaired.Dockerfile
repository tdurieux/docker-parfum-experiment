#
# Copyright IBM Corporation 2021
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
#

ARG base_image=rayproject/ray:1.12.1-py38
FROM ${base_image}

COPY --from=docker.io/apache/camel-k:1.5.1 /usr/local/bin/kamel /usr/local/bin/

RUN sudo apt-get update \
    && sudo apt-get install -y --no-install-recommends openjdk-11-jdk maven \
    && sudo rm -rf /var/lib/apt/lists/* \
    && sudo apt-get clean

ARG rayvens_version
RUN pip install --no-cache-dir rayvens==${rayvens_version}
RUN rayvens-setup.sh --preload
