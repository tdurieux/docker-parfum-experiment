# Copyright 2016 Google Inc.
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

#FROM gcr.io/oss-fuzz-base/base-builder
FROM f1x-oss-fuzz
MAINTAINER even.rouault@spatialys.com
RUN apt-get update && apt-get install --no-install-recommends -y make autoconf automake libtool pkg-config \
        libbz2-dev liblzo2-dev liblzma-dev liblz4-dev libz-dev \
        libxml2-dev libssl-dev libacl1-dev libattr1-dev vim && rm -rf /var/lib/apt/lists/*;
WORKDIR libarchive
COPY scripts $SRC/scripts
COPY build.sh $SRC/
COPY libarchive_testcase /libarchive_testcase
COPY libarchive_fuzzer.cc $SRC/
COPY driver /driver
COPY libarchive $SRC/libarchive
COPY project_build.sh $SRC/libarchive/project_build.sh
COPY project_config.sh $SRC/libarchive/project_config.sh
