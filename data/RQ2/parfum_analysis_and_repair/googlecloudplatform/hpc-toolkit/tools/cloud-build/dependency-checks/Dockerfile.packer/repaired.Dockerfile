# Copyright 2022 Google LLC
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

FROM us-central1-docker.pkg.dev/hpc-toolkit-dev/hpc-toolkit-repo/hpc-toolkit-partial-build:precommit

RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    apt-get -y update && apt-get -y --no-install-recommends install software-properties-common && \
    apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com bullseye main" && \
    apt-get -y update && apt-get -y --no-install-recommends install packer && rm -rf /var/lib/apt/lists/*;
