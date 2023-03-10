# Copyright 2017-2022 EPAM Systems, Inc. (https://www.epam.com/)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM centos:7

# Prerequisites
RUN yum install -y \
                wget \
                curl \
                java-1.8.0-openjdk \
                unzip && rm -rf /var/cache/yum

# API distribution
ARG CP_API_DIST_URL=""
ENV CP_MONITORING_HOME="/opt/monitoring"

RUN cd /tmp && \
    wget -q "$CP_API_DIST_URL" -O cloud-pipeline.tgz && \
    tar -zxf cloud-pipeline.tgz && \
    mkdir -p $CP_MONITORING_HOME && \
    mv bin/monitoring-service.jar $CP_MONITORING_HOME/ && \
    rm -rf /tmp/* && rm cloud-pipeline.tgz

ADD config $CP_MONITORING_HOME/config

ADD init /init
RUN chmod +x /init

CMD ["/init"]
