# Copyright 2018 Google Inc.
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
RUN apt-get update && apt-get install --no-install-recommends -y make autoconf automake libtool pkg-config wget && rm -rf /var/lib/apt/lists/*;
RUN git clone --depth 1 https://gitlab.xiph.org/xiph/ogg.git
RUN git clone --depth 1 https://gitlab.xiph.org/xiph/vorbis.git
RUN svn export https://github.com/mozillasecurity/fuzzdata.git/trunk/samples/ogg decode_corpus
RUN svn export --force https://github.com/mozillasecurity/fuzzdata.git/trunk/samples/vorbis decode_corpus
# TODO: remove `people.xiph.org` lines once upstream build script is updated
RUN mkdir people.xiph.org/
RUN touch people.xiph.org/dummy.ogg
WORKDIR vorbis
COPY build.sh $SRC/
