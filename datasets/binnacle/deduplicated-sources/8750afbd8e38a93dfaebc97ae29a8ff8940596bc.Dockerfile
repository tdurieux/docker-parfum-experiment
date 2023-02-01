# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

############################################################
# Dockerfile to build Traffic Ops container images
# Based on CentOS 7.2
############################################################


FROM centos:7
RUN yum -y install nmap-ncat openssl epel-release
RUN yum -y install jq && yum clean all

RUN mkdir -p /opt/traffic_ops/app/bin /opt/traffic_ops/app/conf/production /opt/traffic_ops/app/db
COPY --from=trafficops-perl /opt/traffic_ops/app/bin/traffic_ops_golang /opt/traffic_ops/app/bin/traffic_ops_golang
COPY --from=trafficops-perl /opt/traffic_ops/app/conf/ /opt/traffic_ops/app/conf

EXPOSE 443
WORKDIR /opt/traffic_ops/app
RUN yum install -y bind-utils net-tools gettext perl-JSON-PP


ADD enroller/server_template.json \
    traffic_ops/config.sh \
    traffic_ops/run-go.sh \
    traffic_ops/to-access.sh \
    /

CMD /run-go.sh
