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
#
################################################################################

FROM gcr.io/oss-fuzz-base/base-builder
#ENV http_proxy 'http://proxy.example.com:80/'
#ENV https_proxy 'https://proxy.example.com:80/'
RUN apt-get update && apt-get install --no-install-recommends -y make autoconf automake libtool && rm -rf /var/lib/apt/lists/*;
RUN git clone --depth 1 https://github.com/DMTF/libspdm.git libspdm && cd libspdm && git submodule update --init    # or use other version control
WORKDIR libspdm
COPY build.sh $SRC/
