# Copyright 2020 Google Inc.
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
#
################################################################################

FROM gcr.io/oss-fuzz-base/base-builder
RUN apt-get update && apt-get install --no-install-recommends -y pkg-config libglib2.0-dev gyp libsqlite3-dev mercurial python3-pip python && rm -rf /var/lib/apt/lists/*;
# Because Ubuntu has really ancient meson out there
RUN pip3 install --no-cache-dir meson ninja

RUN git clone --depth 1 --single-branch --branch master https://gitlab.freedesktop.org/spice/libcacard.git libcacard
RUN git clone --depth 1 https://github.com/nss-dev/nss.git nss
RUN hg clone https://hg.mozilla.org/projects/nspr

WORKDIR libcacard
COPY build.sh $SRC/
