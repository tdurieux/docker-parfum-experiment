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

FROM gcr.io/oss-fuzz-base/base-builder
MAINTAINER kjlubick@chromium.org

RUN apt-get update && apt-get install -y python

RUN git clone 'https://chromium.googlesource.com/chromium/tools/depot_tools.git'
ENV PATH="${SRC}/depot_tools:${PATH}"

# checkout all sources needed to build your project
RUN git clone https://skia.googlesource.com/skia.git

# current directory for build script
WORKDIR skia

RUN python tools/git-sync-deps

COPY build.sh $SRC/

# Dirty, ugly hacks until I land the final result in Skia proper
COPY region_deserialize.options $SRC/skia/region_deserialize.options
COPY BUILD.gn.diff $SRC/skia/BUILD.gn.diff
RUN cat BUILD.gn.diff >> BUILD.gn
COPY region_deserialize.cpp $SRC/skia/fuzz/oss_fuzz/region_deserialize.cpp
