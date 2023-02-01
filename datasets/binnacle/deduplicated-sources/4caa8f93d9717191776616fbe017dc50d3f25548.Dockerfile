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

# ca-certificates: Needed to talk to EC2 API
# e2fsprogs: Needed to mount / format ext4 filesytems
RUN apt-get update && apt-get install --yes \
  bash ca-certificates e2fsprogs systemd \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY /.build/artifacts/protokube /usr/bin/protokube
COPY /.build/artifacts/channels /usr/bin/channels

CMD /usr/bin/protokube
