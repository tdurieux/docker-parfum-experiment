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
RUN apt-get update && apt-get install -y make cmake g++ vim
WORKDIR openjpeg
COPY scripts $SRC/scripts
COPY build.sh $SRC/
COPY openjpeg_testcase /openjpeg_testcase
COPY driver /driver
COPY openjpeg $SRC/openjpeg
COPY project_build.sh $SRC/openjpeg/project_build.sh
COPY project_config.sh $SRC/openjpeg/project_config.sh
