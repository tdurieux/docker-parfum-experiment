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

FROM k8s.gcr.io/debian-base-amd64:0.3

# Install packages:
#  curl (to download golang)
#  git (for getting the current head)
#  gcc make (for compilation)
RUN apt-get update && apt-get install --yes --reinstall lsb-base \
  && apt-get install --yes curl git gcc make bash \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install golang
RUN curl -L https://storage.googleapis.com/golang/go1.12.5.linux-amd64.tar.gz | tar zx -C /usr/local
ENV PATH $PATH:/usr/local/go/bin

COPY onbuild.sh /onbuild.sh
