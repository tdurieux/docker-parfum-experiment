# Copyright 2016 Google Inc.
# Modifications copyright (C) 2021 ISP RAS
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

FROM sweetvishnya/ubuntu20.04-sydr-fuzz

MAINTAINER Andrey Fedotov

# Install build dependencies.
RUN apt-get update && apt-get install -y make autoconf automake libtool

# Clone target from GitHub.
RUN git clone https://github.com/mm2/Little-CMS.git lcms

WORKDIR lcms

# Checkout specified commit. It could be updated later.
RUN git checkout 3534eda7b59fef0dcfd04260820df804941e4f9b

# Copy build script and fuzz targets for libFuzzer and Sydr.
COPY build.sh cmsIT8_load_*.c cms_transform_*.c cms_overwrite_transform_*.c ./

# Build fuzz targets.
RUN ./build.sh

WORKDIR ..
# Prepare seed corpus.
RUN mkdir /corpus && find . -name "*.icc" | xargs -I {} cp {} /corpus/
