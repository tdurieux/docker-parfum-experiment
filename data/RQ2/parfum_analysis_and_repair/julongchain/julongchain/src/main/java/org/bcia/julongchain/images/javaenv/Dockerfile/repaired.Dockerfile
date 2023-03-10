#  Copyright Dingxuan. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
FROM julongchain/julongchain-baseimage
MAINTAINER Julongchain "qkl@dxct.org"
ENV MAVEN_VERSION=3.5.2
ENV USER_HOME_DIR="/root"
RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL https://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
    | tar -xzC /usr/share/maven --strip-components=1 \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"
ADD payload/javashim.tar.bz2 /root
ADD payload/protos.tar.bz2 /root
WORKDIR /root
# Build java shim after copying proto files from fabric/proto
RUN core/smartcontract/shim/java/javabuild.sh
