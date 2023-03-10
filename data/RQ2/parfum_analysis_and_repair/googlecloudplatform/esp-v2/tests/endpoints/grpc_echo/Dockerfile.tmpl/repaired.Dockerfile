# Copyright 2019 Google LLC
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

# To build a docker image for grpc-test-server
#
# Here are the steps:
#
# 1) bazel build //test/grpc:all
# 2) cp bazel-bin/test/grpc/grpc-test-server test/grpc
# 3) IMAGE=gcr.io/endpointsv2/grpc-test-server:latest
# 4) docker build --no-cache -t "${IMAGE}" test/grpc
# 5) gcloud docker -- push "${IMAGE}"

FROM debian:stretch-backports

# Install all of the needed dependencies

RUN apt-get update && \
    apt-get install --no-install-recommends -y -q ca-certificates && \
    apt-get -y -q upgrade && \
    apt-get install -y -q --no-install-recommends \
    apt-utils adduser cron curl logrotate python wget \
    libc6 libgcc1 libstdc++6 libuuid1 && \
    apt-get clean && rm /var/lib/apt/lists/*_*

# Copy TEST_SERVER_BIN binary to the same director as this Dockerfile