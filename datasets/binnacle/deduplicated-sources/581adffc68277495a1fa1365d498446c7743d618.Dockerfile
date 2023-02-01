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
MAINTAINER mike.aizatsky@gmail.com
RUN apt-get update && apt-get install -y make autoconf libtool libarchive-dev

# Get some files for the seed corpus
ADD https://github.com/adobe-fonts/adobe-variable-font-prototype/releases/download/1.001/AdobeVFPrototype.otf $SRC/font-corpus/
RUN git clone https://github.com/unicode-org/text-rendering-tests.git && cp text-rendering-tests/fonts/* $SRC/font-corpus

RUN git clone --depth 1 git://git.sv.nongnu.org/freetype/freetype2.git
WORKDIR freetype2
COPY build.sh *.options $SRC/
