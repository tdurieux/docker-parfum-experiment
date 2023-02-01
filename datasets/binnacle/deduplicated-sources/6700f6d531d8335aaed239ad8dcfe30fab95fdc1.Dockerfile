#
# Copyright 2015-2017 Red Hat, Inc. and/or its affiliates
# and other contributors as indicated by the @author tags.
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
#

FROM jboss/base-jdk:8

MAINTAINER Hawkular Alerting <hawkular-dev@lists.jboss.org>

EXPOSE 8080 9080

COPY target/hawkular-alerting* /opt/hawkular-alerting

USER root
RUN chmod -R 777 /opt

USER jboss
CMD /opt/hawkular-alerting/hawkular.sh console