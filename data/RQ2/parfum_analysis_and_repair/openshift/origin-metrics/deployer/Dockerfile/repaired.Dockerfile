#
# Copyright 2014-2015 Red Hat, Inc. and/or its affiliates
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

FROM openshift/origin:latest

# The image is maintained by the Hawkular Metrics team
MAINTAINER Hawkular Metrics <hawkular-dev@lists.jboss.org>

ENV BIN_DIR=/opt/deploy \
    PROCESSING_DIR=/etc/deploy/_output \
    KUBECONFIG=/etc/deploy/.kubeconfig \
    WRITE_KUBECONFIG=1 \
    SECRET_DIR=/secret

RUN yum install -y java-1.8.0-openjdk openssl httpd-tools bind-utils && yum clean all && rm -rf /var/cache/yum

RUN mkdir -p ${HOME} ${PROCESSING_DIR} ${BIN_DIR} && chmod 777 ${HOME} && chmod 555 ${BIN_DIR}

COPY . ${BIN_DIR}

WORKDIR ${BIN_DIR}

ENTRYPOINT ["./run.sh"]
USER 1000
