# Copyright 2020 Google LLC
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

FROM gcr.io/oss-fuzz-base/base-builder@sha256:1b6a6993690fa947df74ceabbf6a1f89a46d7e4277492addcd45a8525e34be5a

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    make \
    automake \
    autoconf \
    libtool && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/google/woff2.git
RUN git clone https://github.com/google/brotli.git
RUN git clone https://github.com/google/oss-fuzz.git

COPY target.cc build.sh $SRC/
