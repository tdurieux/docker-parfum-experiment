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

FROM gcr.io/oss-fuzz-base/base-builder-jvm

ARG java_home="/out/open-jdk-17"
RUN mkdir -p $java_home

RUN apt update && apt install --no-install-recommends -y openjdk-17-jdk && rm -rf /var/lib/apt/lists/*;
ENV JAVA_HOME $java_home
ENV PATH "${java_home}:${PATH}"
ENV JVM_LD_LIBRARY_PATH "$java_home/lib/server"

RUN git clone --depth 1 https://github.com/spring-projects/spring-boot
RUN git clone --depth 1 https://github.com/spring-projects/spring-framework

COPY build.sh $SRC/
COPY *Fuzzer.java $SRC/
WORKDIR $SRC/spring-boot