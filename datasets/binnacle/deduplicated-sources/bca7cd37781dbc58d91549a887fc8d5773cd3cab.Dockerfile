# Copyright 2018 Google LLC
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


# Build a prebuilt Ruby binary installer

FROM @@RUBY_OS_IMAGE@@ AS builder
ARG ruby_version
RUN cd ${RBENV_ROOT}/plugins/ruby-build \
    && git pull \
    && rbenv install -s ${ruby_version}

FROM scratch
ARG ruby_version
COPY --from=builder \
     /opt/rbenv/versions/${ruby_version} \
     /opt/rbenv/versions/${ruby_version}
