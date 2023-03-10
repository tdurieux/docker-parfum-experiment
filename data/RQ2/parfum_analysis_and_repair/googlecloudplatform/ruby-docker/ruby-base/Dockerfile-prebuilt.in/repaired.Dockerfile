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


# This is the base Dockerfile for an App Engine Ruby runtime.
# Dockerfiles for App Engine Ruby apps should inherit FROM this image.

FROM @@RUBY_OS_IMAGE@@

ARG ruby_version
ARG bundler1_version
ARG bundler2_version

ENV DEFAULT_RUBY_VERSION=${ruby_version}

# Install Ruby from prebuilt image
COPY --from=@@PREBUILT_RUBY_IMAGE@@ \
     /opt/rbenv/versions/${ruby_version} \
     /opt/rbenv/versions/${ruby_version}

# Set default Ruby version and install Bundler