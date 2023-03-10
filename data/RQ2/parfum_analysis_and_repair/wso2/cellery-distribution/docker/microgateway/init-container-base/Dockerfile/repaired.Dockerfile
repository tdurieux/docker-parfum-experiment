# ------------------------------------------------------------------------
#
# Copyright 2018 WSO2, Inc. (http://wso2.com)
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
# limitations under the License
#
# ------------------------------------------------------------------------

# set to latest Ubuntu LTS
FROM ubuntu:18.04

# copy java, microgateway and init.sh file to docker image
COPY ./files/jdk1.8.0_* /java
COPY ./files/wso2am-micro-gw-2.6.1-feature-multi-swagger /wso2am-micro-gw-2.6.1-feature-multi-swagger

# set environment variables
ENV JAVA_HOME=/java
ENV PATH=$JAVA_HOME/bin:$PATH

# install required packages
RUN apt-get update && apt-get install --no-install-recommends -y zip && rm -rf /var/lib/apt/lists/*;
