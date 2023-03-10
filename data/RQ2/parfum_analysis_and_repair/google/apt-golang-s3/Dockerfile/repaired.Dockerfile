# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM golang:1.13

ENV BUILD_DIR /app

RUN mkdir -p $BUILD_DIR
WORKDIR $BUILD_DIR

RUN apt-get update && apt-get install --no-install-recommends ruby-dev -y && rm -rf /var/lib/apt/lists/*;
RUN gem install fpm --no-ri --no-rdoc

COPY . $BUILD_DIR/
