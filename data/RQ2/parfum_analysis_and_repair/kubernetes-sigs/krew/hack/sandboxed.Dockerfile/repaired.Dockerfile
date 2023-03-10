# Copyright 2019 The Kubernetes Authors.
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

FROM gcr.io/gcp-runtimes/ubuntu_16_0_4:latest
RUN apt-get update -qqy && apt-get install --no-install-recommends -qqy git curl wget && rm -rf /var/lib/apt/lists/*;

ARG KUBECTL_VERSION=v1.14.2
RUN curl -fsSLo /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl  && \
    chmod +x /usr/bin/kubectl

# initialize index ahead of time
RUN mkdir -p $HOME/.krew/index && \
    git clone https://github.com/kubernetes-sigs/krew-index $HOME/.krew/index

ENTRYPOINT [ "/usr/bin/env", "bash" ]
